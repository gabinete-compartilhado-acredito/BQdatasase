# destination_table: datastudio.camara_proposicoes_sel_

SELECT siglaTipo, numero, ano, data_apresentacao, ementa, urlInteiroTeor, nome_autor, sigla_partido_autor, uf_autor, lista_autores, tema, lista_temas 
FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_completa`
WHERE siglaTipo IN ('MP','MPV','PDC','PDL','PDS','PDN','PEC','PL','PLP','PLC','PLS','PLN','PLV')
AND data_apresentacao >= '2011-02-01'