SELECT a.*, 
b.NomeParlamentar as nome_parlamentar, 
b.SiglaPartidoParlamentar as sigla_partido, 
b.UfParlamentar as uf
FROM `gabinete-compartilhado.redes_sociais.senadores_twitter_tweet` as a
inner join `gabinete-compartilhado.redes_sociais.senadores_twitter_perfil` as b 
on b.twitter_id = cast(a.user_id as string)
