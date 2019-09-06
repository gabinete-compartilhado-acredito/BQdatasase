WITH e AS (
WITH
  d AS (
  SELECT
    *,
    PARSE_DATE("%Y-%m-%d",
      SPLIT(capture_date, ' ')[ORDINAL(1)]) AS timestamp
  FROM
    `gabinete-compartilhado.camara_v1.liderancas` )
    
SELECT
  timestamp,
  d.nome,
  d.sigla AS sigla_bloco,
  d.lider.ideCadastro AS id_deputado,
  'lider' AS cargo
FROM
  d
UNION ALL
SELECT
  timestamp,
  d.nome,
  d.sigla AS sigla_bloco,
  s.ideCadastro AS id_deputado,
  'vice lider' AS cargo
FROM
  d
CROSS JOIN
  UNNEST(d.vicelider) AS s)

SELECT w1.*, w2.total_membros
FROM e w1
LEFT JOIN `gabinete-compartilhado.analise_congresso_poder.camara_bloco_numero_membros`  w2
ON w1.nome = w2.nome 