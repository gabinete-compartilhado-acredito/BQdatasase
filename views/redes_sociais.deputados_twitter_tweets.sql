SELECT parse_datetime( "%Y-%m-%d %H:%M:%S", capture_date) as capture_date, user.id as user_id, parse_datetime("%a %b %d %H:%M:%S +0000 %Y", created_at) as tweet_created_at, id as tweet_id, full_text, favorite_count, retweet_count, in_reply_to_screen_name, in_reply_to_user_id, in_reply_to_status_id FROM `gabinete-compartilhado.redes_sociais.deputados_tweets`


