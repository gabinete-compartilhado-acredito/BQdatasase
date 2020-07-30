# destination_table: executivo_federal_dou.artigos_cleaned_da_semana

SELECT * 
FROM `gabinete-compartilhado.executivo_federal_dou.artigos_com_campos_cleaned`
WHERE data_pub >= DATE_SUB(CURRENT_DATE('-03'), INTERVAL 7 DAY)