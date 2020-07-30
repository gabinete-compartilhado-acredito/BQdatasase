select parse_datetime( "%Y-%m-%d %H:%M:%S", capture_date) as capture_date, 
parse_datetime("%a %b %d %H:%M:%S +0000 %Y", created_at) as tweet_created_at,
id as tweet_id, 
user.id as tweet_user_id,
parse_datetime("%a %b %d %H:%M:%S +0000 %Y", retweeted_status.created_at) as retweet_created_at, 
retweeted_status.id as retweet_id, 
retweeted_status.user.name as retweet_user_name , 
retweeted_status.user.id as retweet_user_id, 
retweeted_status.full_text as retweet_full_text, 
retweeted_status.favorite_count as retweet_favorite_count,  
retweeted_status.retweet_count, 
in_reply_to_screen_name ,
in_reply_to_user_id, 
in_reply_to_status_id  
from `gabinete-compartilhado.redes_sociais.deputados_tweets` 
where retweeted_status.created_at is not null


