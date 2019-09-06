SELECT t1.*, t2.cargo , t2.score 
FROM (
SELECT
timestamp,
id_deputado,
CASE 
WHEN sigla_bloco = 'Governo' AND cargo = 'lider' THEN 2
WHEN sigla_bloco = 'Governo' AND cargo = 'vice lider' THEN 4
WHEN sigla_bloco != 'Governo' AND cargo = 'lider' THEN 3
WHEN  sigla_bloco != 'Governo' AND cargo = 'vice lider' THEN 4
END AS id_cargo,
sigla_bloco,
total_membros
FROM 
 `gabinete-compartilhado.analise_congresso_poder.camara_liderancas`) t1
JOIN `gabinete-compartilhado.analise_congresso_poder.cargo_score` t2
ON t1.id_cargo = t2.id_cargo 
 