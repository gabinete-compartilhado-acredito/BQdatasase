

WITH d AS (SELECT DISTINCT
t1.nome_parlamentar as nome, 
t2.nome_parlamentar as nome_menor
FROM `gabinete-compartilhado.congresso.camara_deputado` t1
JOIN `gabinete-compartilhado.congresso.camara_deputado` t2
ON t1.nome_parlamentar LIKE CONCAT('%', t2.nome_parlamentar , '%')
AND t1.nome_parlamentar != t2.nome_parlamentar )

SELECT 
LOWER(nome_menor) as nome,
LOWER(ARRAY_TO_STRING(ARRAY_AGG(nome) OVER (PARTITION BY nome_menor), '|')) as regex
FROM d