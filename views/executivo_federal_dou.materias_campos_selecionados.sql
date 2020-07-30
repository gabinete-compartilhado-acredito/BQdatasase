/***
     Tabela com campos selecionados do DOU em colunas separadas. Além disso, fazemos uma limpeza:
     - A seção foi parseada;
     - A data de publicação foi transformadas em DATETIME;
     E criamos os campos:
     - alltext, que agrupa diversos campos num só.
     
     NOTA: No caso de erro "Scalar subquery produced more than one element", isso indica que existem artigos duplicados, talvez por erro 
     na captura (e.g. com artigos com "//" no nome). Nesse caso, descomente as linhas marcadas a baixo para achar o artigo culpado e 
     comente todas as subqueries.
 ***/

-- Agrupa base bruta do DOU nos artigos, mantendo as partições disponíveis:
WITH grouped AS (
  SELECT part_data_pub, part_secao, url,
  ARRAY_AGG(STRUCT(key AS key, value AS value)) as data,
  ANY_VALUE(capture_date) AS capture_date,
  ANY_VALUE(url_certificado) as url_certificado,
  COUNT(DISTINCT key) AS n_keys_distinct,
  COUNT(key) AS n_keys
  FROM `gabinete-compartilhado.executivo_federal_dou.partitioned_bruto_dou`  
  GROUP BY part_data_pub, part_secao, url
)

SELECT
  -- Títulos/Id. do artigo:
  (SELECT value FROM UNNEST(data) WHERE key = 'identifica') AS identifica,
  (SELECT value FROM UNNEST(data) WHERE key = 'orgao-dou-data') AS orgao,
  (SELECT value FROM UNNEST(data) WHERE key = 'titulo') AS ato_orgao,
  (SELECT value FROM UNNEST(data) WHERE key = 'subtitulo') AS subtitulo,
  -- Conteúdo do artigo:
  (SELECT value FROM UNNEST(data) WHERE key = 'ementa') AS ementa, 
  (SELECT value FROM UNNEST(data) WHERE key = 'dou-paragraph') AS paragrafos,
  (SELECT value FROM UNNEST(data) WHERE key = 'dou-em') AS italicos,
  (SELECT value FROM UNNEST(data) WHERE key = 'dou-strong') AS strong,
  (SELECT value FROM UNNEST(data) WHERE key = 'fulltext') AS fulltext,
  -- Concatenação de todos os campos de texto:
    CONCAT(IFNULL((SELECT value FROM UNNEST(data) WHERE key = 'titulo'), ''), ' | ', 
    IFNULL((SELECT value FROM UNNEST(data) WHERE key = 'subtitulo'), ''), ' | ',
    IFNULL((SELECT value FROM UNNEST(data) WHERE key = 'ementa'), ''), ' | ', 
    IFNULL((SELECT value FROM UNNEST(data) WHERE key = 'dou-strong'), ''), ' | ', 
    IFNULL((SELECT value FROM UNNEST(data) WHERE key = 'dou-em'), ''), ' | ', 
    IFNULL((SELECT value FROM UNNEST(data) WHERE key = 'dou-paragraph'), '')) AS alltext,
  -- Resumo criado pelo sistema de captura:
  (SELECT value FROM UNNEST(data) WHERE key = 'resumo') AS resumo,
  -- Primeiro trecho dos parágrafos do artigo (resumo antigo):
  (SELECT 
    CASE ARRAY_LENGTH(SPLIT(value, '|')) > 1
      WHEN FALSE THEN SUBSTR(value, 300) 
      ELSE CONCAT(SUBSTR(SPLIT(value, '|')[OFFSET(0)],1,200), '... | ...', SUBSTR(SPLIT(value, '|')[OFFSET(1)],1,200)) 
    END
    FROM UNNEST(data) WHERE key = 'dou-paragraph'
    ) AS resumo_old, 
  -- Responsáveis pelo artigo:
  (SELECT value FROM UNNEST(data) WHERE key = 'assina') AS assina,
  (SELECT value FROM UNNEST(data) WHERE key = 'cargo') AS cargo,
  -- Id. da publicação: 
  (SELECT CAST((REGEXP_EXTRACT(value, '[0-9]')) AS INT64) FROM UNNEST(data) WHERE key = 'secao-dou') AS secao,
  (SELECT value FROM UNNEST(data) WHERE key = 'edicao-dou-data') AS edicao,
  (SELECT IF(REGEXP_CONTAINS(LOWER(value), 'extra'), 'Extra', 'Ordinária') FROM UNNEST(data) WHERE key = 'secao-dou') AS tipo_edicao,
  (SELECT value FROM UNNEST(data) WHERE key = 'secao-dou-data') AS pagina,
  (SELECT parse_date('%d/%m/%Y', value) FROM UNNEST(data) WHERE key = 'publicado-dou-data') AS data_pub,
  -- Links e info da captura:
  url_certificado,
  url,
  capture_date,
  -- Colunas que definem uma partição:
  part_data_pub,
  part_secao
  --, n_keys, n_keys_distinct,           -- FOR DEBUGGING IN CASE OF ERROR "Scalar subquery produced more than one element" 
FROM grouped
--WHERE n_keys != n_keys_distinct        -- FOR DEBUGGING IN CASE OF ERROR "Scalar subquery produced more than one element" 
--ORDER BY n_keys, n_keys_distinct ASC   -- FOR DEBUGGING IN CASE OF ERROR "Scalar subquery produced more than one element" 

