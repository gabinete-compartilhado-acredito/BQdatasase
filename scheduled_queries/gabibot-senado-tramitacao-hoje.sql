# destination_table: gabi_bot.senado_tramitacao_hoje

SELECT t1.*, t2.participacao, t2.parlamentar 
FROM `gabinete-compartilhado.congresso.senado_tramitacao` t1 
LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.proposicoes_interesse` t2 
ON t1.sigla_tipo=t2.tipo 
AND CAST(t1.numero AS INT64) = CAST(t2.numero AS INT64)
AND CAST(t1.ano AS INT64) = CAST(t2.ano AS INT64)
WHERE date(data_hora) = current_date("America/Sao_Paulo") AND sequencia = 1 ORDER BY data_hora DESC