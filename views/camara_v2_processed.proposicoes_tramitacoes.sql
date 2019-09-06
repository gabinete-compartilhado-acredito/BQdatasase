/***
     Tabela de proposições com informação sobre a última tramitação.
***/

SELECT 
  p.id_proposicao, p.siglaTipo, p.numero, p.ano, p.data_apresentacao, 
  p.ementa, p.lista_temas, p.lista_autores,
  t.data_hora AS data_ultima_tramitacao, t.situacao_agg, t.tramitacao_agg, t.despacho_agg, t.orgao_agg,
  p.urlInteiroTeor
FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_completa` AS p
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.tramitacoes_ultima` AS t
ON p.id_proposicao = t.id_proposicao 