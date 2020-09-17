SELECT tweet_created_at, user_id, full_text, Nome_parlamentar, sigla_partido, uf, favorite_count, retweet_count, split(lower(full_text), " ") as full_text_splited FROM `gabinete-compartilhado.redes_sociais.deputados_twitter_tweets` 
inner join `gabinete-compartilhado.redes_sociais.perfil_twitter_deputados` 
on twitter_id = user_id
inner join `gabinete-compartilhado.redes_sociais.deputados_info` 
on id = Codigo_Parlamentar