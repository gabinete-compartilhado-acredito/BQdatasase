SELECT
  -- Info do usuário:
  user.id AS user_id,
  user.name AS user_name,
  user.screen_name AS user_screen_name,
  PARSE_DATETIME('%a %b %d %H:%M:%S +0000 %Y', user.created_at) AS user_created_at,
  user.description AS user_description,
  user.location AS user_location,
  user.protected AS user_protected,
  user.verified AS user_verified,
  user.followers_count AS user_followers_count,
  user.friends_count AS user_friends_count,
  user.listed_count As user_listed_count,
  user.favourites_count AS user_favourites_count,
  user.statuses_count AS user_statuses_count,
  
  -- Info do tweet:
  PARSE_DATETIME('%a %b %d %H:%M:%S +0000 %Y', created_at) AS created_at,
  id AS tweet_id,
  full_text,
  truncated,
  is_quote_status,
  possibly_sensitive,
  retweet_count,
  favorite_count,
  quoted_status_id,
  in_reply_to_status_id,
  in_reply_to_user_id,
  in_reply_to_screen_name,
  
  -- Info da captura e partições:
  capture_date,
  part_grupo,
  part_user_id,
  part_mes 

FROM `gabinete-compartilhado.redes_sociais.tweets_historicos`