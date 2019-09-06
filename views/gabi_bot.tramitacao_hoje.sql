SELECT *
FROM `gabinete-compartilhado.congresso.tramitacao` 
WHERE date(data_hora) = current_date("America/Sao_Paulo")
ORDER BY data_hora DESC
