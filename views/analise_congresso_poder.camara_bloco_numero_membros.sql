  -- numero de deputados por partido e bloco
WITH
  d AS (
  SELECT
    CASE
      WHEN sigla LIKE '%,%' THEN SPLIT(TRIM(REPLACE(REPLACE(sigla, 'Bloco', ''), ' ', '')))
      ELSE [sigla]
    END blocos,
    nome
  FROM
    `gabinete-compartilhado.camara_v1.liderancas`)
SELECT
  u1.nome,
  SUM(u2.total_membros) as total_membros
FROM (
  SELECT
    DISTINCT
    t1.nome,
    t2.sigla_nova
  FROM (
    SELECT
      d.nome,
      partido 
    FROM
      d
    CROSS JOIN
      UNNEST(d.blocos) AS partido) t1
  JOIN
    `gabinete-compartilhado.congresso.partidos_novas_siglas` t2
  ON
    t1.partido = t2.sigla_antiga ) u1
JOIN
  `gabinete-compartilhado.congresso.camara_partidos_numero_membros` u2
ON
  u1.sigla_nova = u2.sigla_nova
GROUP BY
  u1.nome