SELECT deputado as id_deputado, count(timestamp) as n_votacoes, avg(apoio) as apoio_governo
FROM `gabinete-compartilhado.paineis.camara_orientacao_deputado`
WHERE legislatura = 56 
and data_displaced BETWEEN DATE '2019-02-01' AND current_date() 
and partido_orientacao = 'Governo' 
group by deputado



