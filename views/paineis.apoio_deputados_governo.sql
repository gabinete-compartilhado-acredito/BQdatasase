/***
     Tabela de alinhamento de deputados ao governo na legislatura 56, calculado a partir das votações nominais em plenário.
     Essa análise conta ausências quando o partido do deputado obtrui como obstrução. 
     
     Tabela a ser usada no datastudio.
***/

WITH 
  alinhamento_partido AS (
    SELECT 
      -- Info da votação:
      timestamp, sigla_tipo, numero, ano, obj_votacao, resumo, url_inteiro_teor,
      -- Info do deputado:
      id_deputado, nome, sigla_partido, uf, voto_padronizado,
      -- Info da orientação:
      orientacao_padronizada AS orientacao_partido, apoio AS apoio_partido 
    FROM `gabinete-compartilhado.analise_congresso_votacoes.camara_alinhamentos`
    WHERE partido_orientacao = sigla_partido
  ),
  alinhamento_governo AS (
  SELECT 
    -- Info da votação:
    timestamp, sigla_tipo, numero, ano, obj_votacao, resumo, url_inteiro_teor,
    -- Info do deputado:
    id_deputado, nome, sigla_partido, uf, voto_padronizado,
    -- Info da orientação:
    orientacao_padronizada AS orientacao_governo, apoio AS apoio_temp
  FROM `gabinete-compartilhado.analise_congresso_votacoes.camara_alinhamentos`
  WHERE partido_orientacao = 'Governo'
  )

SELECT 
  -- Info da votação:
  DENSE_RANK() OVER (ORDER BY g.timestamp, g.sigla_tipo, g.numero, g.ano, g.obj_votacao, g.resumo) AS num_votacao,
  g.timestamp, g.sigla_tipo, g.numero, g.ano, g.obj_votacao, g.url_inteiro_teor,
  -- Info do deputado:
  g.id_deputado, g.nome, g.sigla_partido, g.uf, g.voto_padronizado AS voto,
  -- Info da orientação do governo:
  p.orientacao_partido AS orient_part, g.orientacao_governo AS orient_gov, 
  CASE
    WHEN p.orientacao_partido = 'Obstrução' AND p.voto_padronizado = 'Ausente' 
      AND g.orientacao_governo != 'Obstrução' AND g.orientacao_governo != 'Liberado' THEN 0 
    ELSE g.apoio_temp
  END AS apoio

FROM alinhamento_governo AS g
LEFT JOIN alinhamento_partido as p
ON    
  -- Votação:
  g.timestamp = p.timestamp AND g.sigla_tipo = p.sigla_tipo AND g.numero = g.numero AND g.ano = p.ano AND 
  g.obj_votacao = p.obj_votacao AND g.resumo = p.resumo AND
  -- Deputado:
  g.id_deputado = p.id_deputado

WHERE g.timestamp >= '2019-02-01'


