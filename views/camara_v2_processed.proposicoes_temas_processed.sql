/***
     Tabela de temas igual à proposicoes_temas_cleaned, mas com coluna extra:
     O número de proposições de 2011 a 2018 em cada tipo,tema.
***/

-- Tabela de número histórico (de 2011 a 2018) de prosicoes distintas por tipo e tema:
WITH count_historico AS (
  -- Colunas:
  SELECT t.siglaTipo, t.tema, COUNT(DISTINCT t.id_proposicao) AS n_historico
  -- Fontes:
  FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_processed` as p
  ON t.id_proposicao = p.id 
  WHERE p.data_apresentacao >= '2011-02-01' AND p.data_apresentacao <= '2018-12-31'
  GROUP BY t.siglaTipo, t.tema
)

-- Junta com a tabela de tema de proposições (limpa):
-- Colunas:
SELECT t.*, c.n_historico
-- Fontes:
FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` as t
LEFT JOIN count_historico as c
ON t.siglaTipo = c.siglaTipo AND t.tema = c.tema 