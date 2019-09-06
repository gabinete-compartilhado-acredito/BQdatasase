SELECT 
PARSE_DATETIME('%Y-%m-%d', dataInicio) AS data_inicio,
PARSE_DATETIME('%Y-%m-%d', dataFim) AS data_fim,
id AS id_deputado
FROM `gabinete-compartilhado.camara_v2.deputados_mesa`