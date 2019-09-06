SELECT 
t1.idDeputadoAutor AS id_deputado,
t1.idProposicao AS id_proposicao,
t1.nomeAutor as nome_autor,
t1.sigla_nova AS sigla_partido_autor,
t1.siglaUFAutor AS sigla_uf_autor,
t1.tipoAutor AS tipo_autor,
t2.sigla_tipo as sigla_tipo,
t2.numero AS numero,
t2.ano AS ano,
t2.data_apresentacao 
FROM 
  (SELECT w1.*, w2.sigla_nova 
  FROM `gabinete-compartilhado.camara_v2.proposicoes_autores` w1
  LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` w2
  ON w1.siglaPartidoAutor = w2.sigla_antiga ) t1
JOIN `gabinete-compartilhado.congresso.proposicoes_completa` t2
ON t1.idProposicao = t2.id 

