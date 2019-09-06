SELECT  
t1.timestamp,
t1.sigla_tipo,
t1.numero,
t1.ano,
t1.resumo,
t1.obj_votacao,
t1.cod_sessao,
t1.sigla_partido as referencia,
t2.sigla_partido as comparado,
CASE t1.orientacao_bool = t2.orientacao_bool WHEN true THEN 1 ELSE 0 END as apoio
FROM `gabinete-compartilhado.congresso.camara_votacao_bancada` t1
CROSS JOIN `gabinete-compartilhado.congresso.camara_votacao_bancada` t2
WHERE t1.timestamp = t2.timestamp
AND t1.sigla_partido != t2.sigla_partido