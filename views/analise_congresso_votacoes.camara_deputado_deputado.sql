/***
     Esta Tabela retorna o alinhamento, em cada votação desde o início da legislatura 56, 
     de dois deputados diferentes, para todos os deputados.
     
     Note que o alinhamento leva em conta a orientação do partido por obstrução:
     Se o partido do deputado orientou pela obstrução e o parlamentar estava ausente, 
     o voto dele é considerado obstrução. 
     
     Votos ausentes mesmo, de presidente (Art. 17) e Abstenções são ignorados; 
     Demais votos (sim, não, obstrução) são alinhamentos se forem iguais na mesma votação.
 ***/

SELECT  
  -- Info da votação:
  t1.timestamp,
  t1.sigla_tipo,
  t1.numero,
  t1.ano,
  t1.resumo,
  t1.obj_votacao,
  t1.cod_sessao,
  -- Info do deputado 1:
  t1.id_deputado AS id_deputado_1,
  t1.nome AS nome_1,
  t1.sigla_partido AS sigla_partido_1,
  t1.uf AS uf_1,
  t1.voto AS voto_1,
  t1.voto_padronizado AS voto_padronizado_1,
  t1.voto_orientado AS voto_orientado_1,
  -- Info do deputado 2:
  t2.id_deputado AS id_deputado_2,
  t2.nome AS nome_2,
  t2.sigla_partido AS sigla_partido_2,
  t2.uf AS uf_2,
  t2.voto AS voto_2,
  t2.voto_padronizado AS voto_padronizado_2,
  t2.voto_orientado AS voto_orientado_2,
  -- Alinhamento entre os dois deputados:
  CASE
    WHEN t1.voto_orientado IN ('Abstenção', 'Ausente', 'Art. 17') OR t2.voto_orientado IN ('Abstenção', 'Ausente', 'Art. 17')
    THEN NULL
    WHEN t1.voto_orientado = t2.voto_orientado THEN 1
    ELSE 0
  END AS alinhamento
  
FROM       `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_deputado_orientado` AS t1
CROSS JOIN `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_deputado_orientado` AS t2

-- Linka dados dentro das mesmas votações:
WHERE t1.timestamp = t2.timestamp 
AND t1.sigla_tipo = t2.sigla_tipo 
AND t1.numero = t2.numero
AND t1.ano = t2.ano
AND t1.resumo = t2.resumo
AND t1.obj_votacao = t2.obj_votacao
AND t1.cod_sessao = t2.cod_sessao

-- Retira auto-correlações:
AND t1.id_deputado != t2.id_deputado

-- Restringue às votações desde 2019:
AND t1.timestamp >= '2019-02-01'