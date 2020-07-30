SELECT parse_datetime( "%Y-%m-%d %H:%M:%S", capture_date) as capture_date, user.id, user.name, user.screen_name, user.description, parse_datetime("%a %b %d %H:%M:%S +0000 %Y", user.created_at) as user_created_at, a.display_url, user.location FROM `gabinete-compartilhado.redes_sociais.deputados_tweets` as t,
unnest( user.entities.url.urls) as a
group by capture_date, user.id,user.name, user.screen_name, user.description, user_created_at, user.location, a.display_url
order by capture_date desc, user.id

