
SELECT  
t1.timestamp,
t1.sigla_tipo,
t1.numero,
t1.ano,
t1.resumo,
t1.obj_votacao,
t1.cod_sessao,
t1.sigla_partido as partido_orientacao,
t1.orientacao,
t1.orientacao_bool,
t2.id_deputado as deputado,
t2.nome as nome_deputado,
t2.sigla_partido as partido_deputado,

t2.voto,
CASE t1.orientacao = t2.voto  WHEN true THEN 1 ELSE 0 END as apoio
FROM `gabinete-compartilhado.congresso.camara_votacao_bancada` t1
CROSS JOIN `gabinete-compartilhado.congresso.camara_votacao_deputado`  t2
WHERE t1.timestamp = t2.timestamp
AND t1.resumo = t2.resumo
AND t1.obj_votacao = t2.obj_votacao
AND t1.id_proposicao = t2.id_proposicao 