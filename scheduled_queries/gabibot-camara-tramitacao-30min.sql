# destination_table: gabi_bot.camara_tramitacao_last30minutos

SELECT t1.*, t2.participacao, t2.parlamentar
FROM `gabinete-compartilhado.congresso.tramitacao` t1
LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.proposicoes_interesse` t2
ON t1.sigla_tipo=t2.tipo
AND t1.numero=t2.numero
AND t1.ano=t2.ano
WHERE data_hora BETWEEN 
DATETIME_SUB(DATETIME(current_timestamp() , "America/Sao_Paulo"), interval 40 minute) and 
DATETIME_SUB(DATETIME(current_timestamp() , "America/Sao_Paulo"), interval 10 minute)