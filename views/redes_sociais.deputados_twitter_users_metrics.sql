SELECT  parse_datetime( "%Y-%m-%d %H:%M:%S", capture_date) as capture_date, user.id, user.favourites_count, user.followers_count, user.friends_count, user.statuses_count FROM `gabinete-compartilhado.redes_sociais.deputados_tweets` 
group by capture_date, user.id, user.favourites_count, user.followers_count, user.friends_count, user.statuses_count
order by capture_date desc, user.id