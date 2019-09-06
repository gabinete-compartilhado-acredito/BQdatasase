# destination_table: paineis.proposicoes_displaced

WITH
 d AS (
 SELECT
 *,
 DATETIME_DIFF(DATETIME "2019-02-01",
 data_apresentacao,
 YEAR) AS diff
 FROM (
 SELECT
 t1.*,
 t2.ano_primeira_aparicao,
 t2.legislatura AS legislatura_primeira_aparicao,
 t2.primeiro_mandato
 FROM
 `gabinete-compartilhado.congresso.proposicoes_completa` t1
 JOIN
 `gabinete-compartilhado.congresso.deputado_ano_inicial` t2
 ON
 t1.id_deputado = t2.id_deputado) )
SELECT
 *,
 CASE
 WHEN d.diff BETWEEN -3 AND 0 THEN 56
 WHEN d.diff BETWEEN 1
 AND 4 THEN 55
 WHEN d.diff BETWEEN 5 AND 8 THEN 54
 WHEN d.diff BETWEEN 9
 AND 12 THEN 53
 WHEN d.diff BETWEEN 13 AND 16 THEN 52
 WHEN d.diff BETWEEN 17
 AND 20 THEN 51
 WHEN d.diff BETWEEN 21 AND 24 THEN 50
 WHEN d.diff BETWEEN 25
 AND 28 THEN 49
 WHEN d.diff BETWEEN 29 AND 32 THEN 48
 END AS legislatura,
 CASE
 WHEN d.diff BETWEEN -3 AND 0 THEN data_apresentacao
 WHEN d.diff BETWEEN 1
 AND 4 THEN datetime_add(data_apresentacao,
 INTERVAL 4 year)
 WHEN d.diff BETWEEN 5 AND 8 THEN datetime_add(data_apresentacao, INTERVAL 8 year)
 WHEN d.diff BETWEEN 9
 AND 12 THEN datetime_add(data_apresentacao,
 INTERVAL 12 year)
 WHEN d.diff BETWEEN 13 AND 16 THEN datetime_add(data_apresentacao, INTERVAL 16 year)
 WHEN d.diff BETWEEN 17
 AND 20 THEN datetime_add(data_apresentacao,
 INTERVAL 20 year)
 WHEN d.diff BETWEEN 21 AND 24 THEN datetime_add(data_apresentacao, INTERVAL 24 year)
 WHEN d.diff BETWEEN 25
 AND 28 THEN datetime_add(data_apresentacao,
 INTERVAL 28 year)
 WHEN d.diff BETWEEN 29 AND 32 THEN datetime_add(data_apresentacao, INTERVAL 32 year)
 END AS data_displaced
FROM
 d