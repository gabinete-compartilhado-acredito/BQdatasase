SELECT * except (temas, tema, n_votacoes)
FROM `gabinete-compartilhado.analise_congresso_votacoes.votacoes_v2_deputado_deputado_por_tema`, 
unnest(temas) as tema
inner join `gabinete-compartilhado.bruto_gabinete_administrativo.temas_proposicoes_camara_agg_macro-temas` as a 
on a.tema = tema 