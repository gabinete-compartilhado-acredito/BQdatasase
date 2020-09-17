SELECT id_str as tweet_id, a.text as hashtag FROM `gabinete-compartilhado.redes_sociais.senadores_tweets`,
unnest(entities.hashtags) a