SELECT *
FROM `gabinete-compartilhado.gabi_bot.senado_tramitacao_hoje` 
WHERE data_hora BETWEEN 
DATETIME_SUB(DATETIME(current_timestamp() , "America/Sao_Paulo"), interval 40 minute) and 
DATETIME_SUB(DATETIME(current_timestamp() , "America/Sao_Paulo"), interval 10 minute)