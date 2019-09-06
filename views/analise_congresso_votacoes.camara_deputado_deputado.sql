SELECT  
t1.timestamp,
t1.sigla_tipo,
t1.numero,
t1.ano,
t1.resumo,
t1.obj_votacao,
t1.cod_sessao,
t1.id_deputado as id_deputado_referencia,
t1.sigla_partido as partido_deputado_referencia,
t1.nome as nome_deputado_referencia,
t2.id_deputado as id_deputado_comparacao,
t2.sigla_partido as partido_deputado_comparacao,
t2.nome as nome_deputado_comparacao,
CASE t1.voto_bool = t2.voto_bool  WHEN true THEN 1 ELSE 0 END as apoio
FROM `gabinete-compartilhado.congresso.camara_votacao_deputado` t1
CROSS JOIN `gabinete-compartilhado.congresso.camara_votacao_deputado`  t2
WHERE t1.timestamp = t2.timestamp
AND t1.id_deputado != t2.id_deputado 