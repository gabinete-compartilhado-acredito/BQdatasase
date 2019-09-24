-- Junta a tabela de comissionados com informações sobre o respectivo parlamentar:
SELECT d.ultimoStatus_nome AS nome_deputado, d.nome_civil, d.sigla_partido_original, d.sigla_partido, d.uf, c.* 
FROM `gabinete-compartilhado.camara_v1_processed.deputados_comissionados_cleaned` AS c
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d
ON c.id_deputado = d.id