SELECT CAST(ARRAY_REVERSE(SPLIT(uri, '/'))[ORDINAL(1)] AS INT64) as id , * 
FROM `gabinete-compartilhado.camara_v2.deputados` 
