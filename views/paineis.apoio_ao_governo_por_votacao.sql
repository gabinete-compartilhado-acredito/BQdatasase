-- Government orientation in each voting session (not including Liberados & Abstenções) --
WITH g AS (SELECT *
           FROM `gabinete-compartilhado.congresso.camara_votacao_bancada` as g
           WHERE sigla_partido = 'Governo'
           )

-- Table with voting question, representative's vote and government orientation --
SELECT v.timestamp, v.id_deputado, v.nome, v.sigla_partido, v.uf, v.voto, v.sigla_tipo, v.numero, v.ano, v.ementa, v.obj_votacao, v.resumo,
       g.orientacao as orient_gov, 
       IF (g.orientacao IS NULL, NULL, IF (v.voto = g.orientacao, 1, 0)) AS apoio
FROM `gabinete-compartilhado.congresso.camara_votacao_deputado` as v
LEFT JOIN g 
ON v.timestamp = g.timestamp
AND v.resumo = g.resumo
AND v.obj_votacao = g.obj_votacao
AND v.id_proposicao = g.id_proposicao
