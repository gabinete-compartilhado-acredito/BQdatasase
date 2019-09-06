WITH d AS (SELECT 
id_deputado, 
MIN(EXTRACT(year FROM data_apresentacao)) AS ano_primeira_aparicao 
FROM `gabinete-compartilhado.congresso.proposicoes_completa`
GROUP BY id_deputado)

SELECT 
*,
CASE
WHEN d.ano_primeira_aparicao BETWEEN 2019 AND 2022 THEN 56
WHEN d.ano_primeira_aparicao BETWEEN 2015 AND 2018 THEN 55
WHEN d.ano_primeira_aparicao BETWEEN 2011 AND 2014 THEN 54
WHEN d.ano_primeira_aparicao BETWEEN 2007 AND 2010 THEN 53
WHEN d.ano_primeira_aparicao BETWEEN 2003 AND 2006 THEN 52
WHEN d.ano_primeira_aparicao BETWEEN 1999 AND 2002 THEN 51
WHEN d.ano_primeira_aparicao BETWEEN 1995 AND 1998 THEN 50
WHEN d.ano_primeira_aparicao BETWEEN 1991 AND 1994 THEN 49
WHEN d.ano_primeira_aparicao BETWEEN 1987 AND 1990 THEN 48
WHEN d.ano_primeira_aparicao BETWEEN 1983 AND 1986 THEN 47
END as legislatura,
CASE 
WHEN d.ano_primeira_aparicao BETWEEN 2019 AND 2022 THEN 'Sim'
ELSE 'Não'
END as primeiro_mandato
FROM d