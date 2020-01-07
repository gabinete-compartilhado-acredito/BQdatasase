/***
     Tabela de alinhamento de deputados ao governo na legislatura 56, calculado a partir das votações nominais em plenário.
     Essa análise conta ausências quando o partido do deputado obtrui como obstrução. 
     
     Tabela a ser usada no datastudio.
***/

WITH 
  alinhamento_partido AS (
    SELECT 
      -- Info da votação:
      timestamp, sigla_tipo, numero, ano, obj_votacao, resumo,
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
    timestamp, sigla_tipo, numero, ano, obj_votacao, resumo,
    -- Info do deputado:
    id_deputado, nome, sigla_partido, uf, voto_padronizado,
    -- Info da orientação:
    orientacao_padronizada AS orientacao_governo, apoio AS apoio_temp
  FROM `gabinete-compartilhado.analise_congresso_votacoes.camara_alinhamentos`
  WHERE partido_orientacao = 'Governo'
  )

SELECT 
  -- Info da votação (e da proposição em questão):
  DENSE_RANK() OVER (ORDER BY g.timestamp, g.sigla_tipo, g.numero, g.ano, g.obj_votacao, g.resumo) AS num_votacao,
  g.timestamp, d.id AS id_proposicao, g.sigla_tipo, g.numero, g.ano, g.obj_votacao, d.urlInteiroTeor,
  -- Info do deputado:
  g.id_deputado, g.nome, g.sigla_partido, g.uf, g.voto_padronizado AS voto,
  -- Info das orientações:
  g.orientacao_proprio_partido AS orient_part, g.orientacao_padronizada AS orient_gov, 
  -- Alinhamento ao partido:
  g.apoio_proprio_partido,
  -- Alinhamento ao governo:
  CASE
    WHEN g.orientacao_proprio_partido = 'Obstrução' AND g.voto_padronizado = 'Ausente' 
      AND g.orientacao_padronizada != 'Obstrução' AND g.orientacao_padronizada != 'Liberado' THEN 0 
    ELSE g.apoio
  END AS apoio,
  -- Quórum da votação:
  IF(g.voto_padronizado IN ('Sim', 'Não', 'Abstenção', 'Art. 17'), 1, 0) AS quorum

FROM `gabinete-compartilhado.analise_congresso_votacoes.camara_alinhamentos` AS g

-- Junta com tabela sobre as proposições:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS d
ON g.sigla_tipo = d.siglaTipo AND g.ano = d.ano AND g.numero = d.numero

-- Seleciona apenas orientações (e alinhamentos) do governo:
-- Seleciona apenas votações da atual legislatura:
WHERE g.partido_orientacao = 'Governo' 
AND g.timestamp >= '2019-02-01'


