/***
    Esta tabela consolida todas as informações (traça um perfil) dos deputados, em formato de apresentação:
    - Temas de interesse;
    - Bancadas (segundo levantamento da Pública 2016);
    - Alinhamento com próprio partido;
    - Alinhamento com governo;
    - Alinhamento com Tabata;
    - Alinhamento com Rigoni.
 ***/

-- Tabela que consolida os 5 temas de maior interesse do deputado numa string:
WITH tab_temas AS (
  SELECT 
    id_deputado, ultimoStatus_nome, sigla_partido, uf, 
    STRING_AGG(CONCAT(tema , " (", CAST(ROUND(n_intervencoes/n_total*100, 1) AS STRING), "%)"), '\n' ORDER BY n_intervencoes DESC LIMIT 5) AS temas
  FROM `gabinete-compartilhado.analise_congresso_atividade.deputados_temas_interesse_consolidado`
  GROUP BY id_deputado, ultimoStatus_nome, sigla_partido, uf
)

SELECT 
  -- Temas de interesse e bancadas (Pública 2016):
  t.*, b.bancadas, 
  -- Alinhamento com próprio partido e governo:
  g.alinhamento_partido, g.alinhamento_gov,
  -- Alinhamento com parlamentares do Acredito:
  tabata.alinhamento AS alinhamento_tabata, rigoni.alinhamento AS alinhamento_rigoni
  
FROM tab_temas AS t 
LEFT JOIN `gabinete-compartilhado.analise_congresso_poder.camara_bancadas_publica_consolidado` AS b
ON t.id_deputado = b.id 
LEFT JOIN `gabinete-compartilhado.analise_congresso_votacoes.alinhamento_tabata_deputados` AS tabata
ON t.id_deputado = tabata.id_deputado_2 
LEFT JOIN `gabinete-compartilhado.analise_congresso_votacoes.alinhamento_rigoni_deputados` AS rigoni
ON t.id_deputado = rigoni.id_deputado_2 
LEFT JOIN `gabinete-compartilhado.paineis.apoio_deputados_governo_consolidado`  AS g
ON t.id_deputado = g.id_deputado 