SELECT a.*, 
Nome_parlamentar, 
sigla_partido, 
uf
FROM `gabinete-compartilhado.redes_sociais.deputados_twitter_tweets` as a
inner join `gabinete-compartilhado.redes_sociais.perfil_twitter_deputados` 
on twitter_id = user_id
inner join `gabinete-compartilhado.redes_sociais.deputados_info` 
on id = Codigo_Parlamentar
