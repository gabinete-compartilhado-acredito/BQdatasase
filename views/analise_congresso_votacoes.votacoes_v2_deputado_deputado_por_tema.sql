/***
  Mesmo que a tabela 'votacoes_v2_deputado_deputado', mas com uma coluna
  extra com um array de temas afetados pela votação e outra coluna 
  extra com os macrotemas (que agrupam os temas em supergrupos, de acordo 
  com especificação dada em Google sheets.
 ***/

-- Tabela que lista (em um array) os temas afetados por cada votação:
WITH tab_temas AS (
  SELECT 
    p.id_votacao,
    ARRAY_AGG(DISTINCT t.tema_unico IGNORE NULLS ORDER BY t.tema_unico) AS temas,
    ARRAY_AGG(DISTINCT m.tema_agrupado IGNORE NULLS ORDER BY m.tema_agrupado) AS macrotemas

  FROM `gabinete-compartilhado.camara_v2_processed.votacoes_proposicoes_afetadas` AS p
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_definitivo` AS t
  ON p.id_afetada = t.id_prop_1
  LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.camara_proposicoes_temas_macrotemas` AS m
  ON t.tema_unico = m.tema
  GROUP BY p.id_votacao
)

-- Tabela principal --
SELECT v.*, t.temas, t.macrotemas
FROM `gabinete-compartilhado.analise_congresso_votacoes.votacoes_v2_deputado_deputado` AS v
LEFT JOIN tab_temas AS t ON v.id_votacao = t.id_votacao
