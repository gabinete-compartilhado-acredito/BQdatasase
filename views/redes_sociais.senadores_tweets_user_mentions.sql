SELECT b.id_str as tweet_id, a.id_str as user_mentioned_id, a.name, a.screen_name  FROM `gabinete-compartilhado.redes_sociais.senadores_tweets` as b,
unnest(entities.user_mentions) a