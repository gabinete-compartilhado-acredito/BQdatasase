SELECT  parse_datetime( "%Y-%m-%d %H:%M:%S", capture_date) as capture_date, 
parse_datetime("%a %b %d %H:%M:%S +0000 %Y", created_at) as tweet_created_at,
user.screen_name,
user.id as user_id, 
full_text,
split(lower(REGEXP_REPLACE(full_text, r"([;:\.,\-\"\'])\D", " ")), " ") as full_text_splited,
lower(REGEXP_REPLACE(full_text, r"([;:\.,\-\"\'])\D", " ")) as full_text_lower,
favorite_count, 
retweet_count,
REGEXP_EXTRACT_ALL(lower(full_text), "#[a-z_0-9áàâãéèêíïóôõöúçñ]+") as hashtags, 
REGEXP_EXTRACT_ALL(lower(full_text), "@[a-zA-Z_0-9]+") as profile_mentioned,
concat("twitter.com/", user.screen_name, "/status/", id_str) as tweet_link
FROM `gabinete-compartilhado.redes_sociais.deputados_tweets`

