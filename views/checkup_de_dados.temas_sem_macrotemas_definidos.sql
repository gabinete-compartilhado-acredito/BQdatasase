-- Verifica se existem temas de proposições sem vinculação a macrotemas (definidos em Google sheets).
-- Se tudo estiver correto, essa query deve retornar 0 linhas. Se existirem temas sem macrotemas 
-- associados, eles aparecerão aqui.

SELECT DISTINCT tema, a.tema_agrupado
FROM `gabinete-compartilhado.analise_congresso_votacoes.votacoes_v2_deputado_deputado_por_tema` AS v, 
UNNEST(v.temas) AS tema
LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.camara_proposicoes_temas_macrotemas` AS a
ON tema = a.tema
WHERE tema_agrupado IS NULL