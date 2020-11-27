# destination_table: redes_sociais.projeto_twitter

SELECT 'Deputado Federal' as titulo, * FROM `gabinete-compartilhado.redes_sociais.deputados_tweets_cleaned` 
union all
SELECT 'Senador' as titulo, * FROM `gabinete-compartilhado.redes_sociais.senadores_tweets_cleaned`