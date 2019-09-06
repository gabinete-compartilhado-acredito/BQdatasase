WITH
  d AS (
  SELECT
    DISTINCT
    PARSE_DATETIME('%d/%m/%Y %H:%M',
      CONCAT(t1.Data, ' ', t1.Hora)) AS timestamp,
    Nome AS nome,
    ObjVotacao AS obj_votacao,
    t2.sigla_nova AS sigla_partido,
    TRIM(t1.Partido) as sigla_partido_original,
    Resumo AS resumo,
    UF AS uf,
    TRIM(Voto) AS voto,
    codSessao AS cod_sessao,
    ideCadastro AS id_deputado,
    SPLIT(SPLIT(SPLIT(t1.api_url, '?')[ORDINAL(2)], '&')[ORDINAL(1)], '=')[ORDINAL(2)] AS sigla_tipo,
    CAST(SPLIT(SPLIT(SPLIT(t1.api_url, '?')[ORDINAL(2)], '&')[ORDINAL(2)], '=')[ORDINAL(2)] AS INT64) AS numero,
    CAST(SPLIT(SPLIT(SPLIT(t1.api_url, '?')[ORDINAL(2)], '&')[ORDINAL(3)], '=')[ORDINAL(2)] AS INT64) AS ano
  FROM
    `gabinete-compartilhado.camara_v1.proposicao_votacao_deputado` t1
   JOIN
    `gabinete-compartilhado.congresso.partidos_novas_siglas` t2
   ON
   TRIM(t1.Partido) = t2.sigla_antiga )

SELECT
  l1.*,
  l2.id AS id_proposicao,
  l2.ementa ,
  CASE
    WHEN voto = 'Obstrução' THEN 0
    WHEN voto = 'Não' THEN 0
    WHEN voto = 'Sim' THEN 1
  END AS voto_bool
FROM
  d l1
JOIN
  `gabinete-compartilhado.congresso.proposicoes_completa` l2
ON
  l1.sigla_tipo = l2.sigla_tipo
  AND l1.ano = l2.ano
  AND l1.numero = l2.numero
-- Selection below replaces the previous one (commented). hsxavier on 2019-06-05:
WHERE
  voto NOT IN ('Art. 17',
--    'Abstenção',
    '-')
