-- Tabela proposicao_votacao_bancada com todas as siglas novas, expandido os blocos:
WITH k AS (
  -- Adiciona uma coluna às votações das bancadas com array de partidos no bloco:
  WITH d AS (
    SELECT
          *,
          CASE
            WHEN Sigla LIKE '%/%' THEN SPLIT(Sigla, '/')
            WHEN UPPER(Sigla) = Sigla THEN [Sigla]
            WHEN Sigla LIKE 'Repr.%'  THEN [REPLACE(Sigla, 'Repr.', '')]
            ELSE REGEXP_EXTRACT_ALL(Sigla, "([A-Z]?[^A-Z]+)")
          END as sigla_filtered
    FROM `gabinete-compartilhado.camara_v1.proposicao_votacao_bancada`
    )

  -- Tabela proposicao_votacao_bancada com todas as siglas novas, mesmo nos blocos:
  SELECT 
    PARSE_DATETIME('%d/%m/%Y %H:%M', CONCAT(t1.Data, ' ', t1.Hora)) AS timestamp,
    t1.ObjVotacao as obj_votacao,
    t1.Resumo as resumo,
    SPLIT(SPLIT(t1.api_url, '?')[ordinal(2)], '&') AS proposicao,
    t1.codSessao as cod_sessao,
    t1.orientacao,
    t1.Sigla AS sigla_original,
    t2.sigla_nova as sigla
  FROM (
    -- Tabela proposicao_votacao_bancada expandida para todos os partidos nos blocos:
    SELECT d.*, TRIM(UPPER(REGEXP_EXTRACT(sigla_flattened, "[A-z]*"))) AS sigla_flattened
    FROM d CROSS JOIN UNNEST(d.sigla_filtered) AS sigla_flattened
    ) AS t1
  LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS t2
  ON t1.sigla_flattened = t2.sigla_antiga
  )

SELECT DISTINCT 
l1.*,
l2.id as id_proposicao, l2.url_inteiro_teor,
CASE 
  WHEN l1.orientacao =  'Sim' THEN 1 
  WHEN l1.orientacao =  'Não' THEN 0 
  WHEN l1.orientacao =  'Obstrução' THEN 0 
END as orientacao_bool
FROM (
  -- Tabela de orientações (já expandida e com siglas novas), e identificação da proposição organizada: 
  SELECT 
    k.timestamp,
    k.obj_votacao,
    k.resumo,
    k.cod_sessao,
    TRIM(k.orientacao) as orientacao,
    k.sigla_original AS sigla_partido_original,
    k.sigla as sigla_partido,
    SPLIT(k.proposicao[ordinal(1)], '=')[ordinal(2)] as sigla_tipo,
    CAST(SPLIT(k.proposicao[ordinal(2)], '=')[ordinal(2)] AS INT64) as numero,
    CAST(SPLIT(k.proposicao[ordinal(3)], '=')[ordinal(2)] AS INT64) as ano
  FROM k
  ) AS l1
-- Junta com informações sobre a proposição:  
JOIN `gabinete-compartilhado.congresso.proposicoes_completa` AS l2
  ON l1.sigla_tipo = l2.sigla_tipo
  AND l1.ano = l2.ano
  AND l1.numero = l2.numero
--WHERE l1.orientacao NOT IN ('Liberado', 'Abstenção') 
WHERE TRIM(l1.orientacao) NOT IN ('Liberado', 'Abstenção') -- Alteraçao feita por hsxavier em 2019-06-05


