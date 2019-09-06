SELECT *
FROM `gabinete-compartilhado.executivo_federal_dou.artigos_com_campos_sel`  
WHERE capture_date BETWEEN 
DATETIME_SUB(DATETIME(current_timestamp()), interval 30 minute) AND 
DATETIME_SUB(DATETIME(current_timestamp()), interval 1 second)


/* Query for testing a certain "current_time" */
/*
SELECT *
FROM `gabinete-compartilhado.executivo_federal_dou.artigos_com_campos_sel`  
WHERE capture_date BETWEEN 
DATETIME_SUB(PARSE_DATETIME('%Y-%m-%d %H:%M:%S', '2019-05-20 14:00:00'), interval 30 minute) AND 
DATETIME_SUB(PARSE_DATETIME('%Y-%m-%d %H:%M:%S', '2019-05-20 14:00:00'), interval 1 second)
ORDER BY capture_date
*/

