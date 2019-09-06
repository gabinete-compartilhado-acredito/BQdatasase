WITH k AS (
WITH d AS (
SELECT
      *,
      CASE
      WHEN Sigla LIKE '%/%' THEN SPLIT(Sigla, '/')
      WHEN UPPER(Sigla) = Sigla THEN [Sigla]
      WHEN Sigla LIKE 'Repr.%'  THEN [REPLACE(Sigla, 'Repr.', '')]
      ELSE REGEXP_EXTRACT_ALL(Sigla, "([A-Z]?[^A-Z]+)")
      END as sigla_filtered
FROM `gabinete-compartilhado.camara_v1.proposicao_votacao_bancada` )


SELECT 
      PARSE_DATETIME('%d/%m/%Y %H:%M', CONCAT(t1.Data, ' ', t1.Hora)) as timestamp,
      t1.ObjVotacao as obj_votacao,
      t1.Resumo as resumo,
      SPLIT(SPLIT(t1.api_url, '?')[ordinal(2)], '&') as proposicao,
      t1.codSessao as cod_sessao,
      t1.orientacao,
      sigla_nova as sigla
FROM (
SELECT d.*, TRIM(UPPER(REGEXP_EXTRACT(sigla_flattened, "[A-z]*"))) as sigla_flattened
FROM d
CROSS JOIN UNNEST(d.sigla_filtered) AS sigla_flattened) t1
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` t2
ON t1.sigla_flattened = t2.sigla_antiga)

SELECT 
DISTINCT 
l1.*,
l2.id as id_proposicao, l2.url_inteiro_teor,
CASE 
WHEN l1.orientacao =  'Sim' THEN 1 
WHEN l1.orientacao =  'Não' THEN 0 
WHEN l1.orientacao =  'Obstrução' THEN 0 
END as orientacao_bool
FROM (
SELECT 
k.timestamp,
k.obj_votacao,
k.resumo,
k.cod_sessao,
TRIM(k.orientacao) as orientacao,
k.sigla as sigla_partido,
SPLIT(proposicao[ordinal(1)], '=')[ordinal(2)] as sigla_tipo,
CAST(SPLIT(proposicao[ordinal(2)], '=')[ordinal(2)] AS INT64) as numero,
CAST(SPLIT(proposicao[ordinal(3)], '=')[ordinal(2)] AS INT64) as ano
FROM k) l1
JOIN `gabinete-compartilhado.congresso.proposicoes_completa` l2
ON l1.sigla_tipo = l2.sigla_tipo
AND l1.ano = l2.ano
AND l1.numero = l2.numero
--WHERE l1.orientacao NOT IN ('Liberado', 'Abstenção') 
WHERE TRIM(l1.orientacao) NOT IN ('Liberado', 'Abstenção') -- Alteraçao feita por hsxavier em 2019-06-05


