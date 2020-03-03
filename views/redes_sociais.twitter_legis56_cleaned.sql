SELECT
  -- Info do autor do tweet:
  author_id,
  username,
  -- Info do tweet:
  tweet_id,
  PARSE_DATETIME('%a %b %d %H:%M:%S +0000 %Y', date) as formatted_date,
  SPLIT(date, ' ')[ORDINAL(1)] as week_day,
  -- Conteúdo do tweet:
  d.to,
  text,
  mentions,
  hashtags,
  url,
  -- Estatísticas do tweet:
  likes,
  replies,
  retweets,
  -- URL do tweet:
  tweet_link,
  -- Info da captura:
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", d.capture_date) AS capture_date
  
FROM `gabinete-compartilhado.redes_sociais.twitter_legis56` AS d
