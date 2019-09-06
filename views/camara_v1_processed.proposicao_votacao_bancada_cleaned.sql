/***  Tabela bruta proposicao_votacao_bancada com colunas adicionais, organizadas:
      - Partidos listados como membros do bloco são expandidos e colocados em siglas novas;
      - timestamp (DATETIME) criado;
      - Extraímos info da proposição da api_url. 
 ***/ 

-- Adiciona uma coluna às votações das bancadas com array de partidos no bloco:
WITH d AS (
  SELECT
    *,
    -- Cria array de partidos dos blocos:
    CASE
      WHEN Sigla LIKE '%/%' THEN SPLIT(Sigla, '/')
      WHEN UPPER(Sigla) = Sigla THEN [Sigla]
      WHEN Sigla LIKE 'Repr.%'  THEN [REPLACE(Sigla, 'Repr.', '')]
      ELSE REGEXP_EXTRACT_ALL(Sigla, "([A-Z]+[a-zçã]+B?)") -- Old Joao's expression: ([A-Z]?[^A-Z]+)
    END as sigla_array,
    -- Aproveita para pré-selecionar info da proposição (cria um ARRAY):
    SPLIT(SPLIT(api_url, '?')[ordinal(2)], '&') AS proposicao
  FROM `gabinete-compartilhado.camara_v1.proposicao_votacao_bancada`
  )

-- Tabela proposicao_votacao_bancada expandida com todas as siglas novas, mesmo nos blocos:
SELECT
  -- Info da votação:
  PARSE_DATETIME('%d/%m/%Y %H:%M', CONCAT(d.Data, ' ', d.Hora)) AS timestamp,
  d.Data, d.Hora,
  d.codSessao as cod_sessao,
  SPLIT(d.proposicao[ORDINAL(1)], '=')[ORDINAL(2)] AS sigla_tipo,
  CAST(SPLIT(d.proposicao[ORDINAL(2)], '=')[ORDINAL(2)] AS INT64) AS numero,
  CAST(SPLIT(d.proposicao[ORDINAL(3)], '=')[ORDINAL(2)] AS INT64) AS ano,
  d.ObjVotacao as obj_votacao,
  d.Resumo as resumo,
  -- Info das bancadas:
  d.Sigla as sigla_original,
  TRIM(d.orientacao) AS orientacao, -- Cleaned column.
  n.sigla_nova as sigla,
  -- Info da captura:
  d.api_url,
  d.capture_date
-- Expande partidos nos blocos:
FROM d, UNNEST(d.sigla_array) AS sigla_flattened
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS n
-- Traduz as siglas velhas nas novas:
ON TRIM(UPPER(REGEXP_EXTRACT(sigla_flattened, "[A-z]*"))) = n.sigla_antiga

