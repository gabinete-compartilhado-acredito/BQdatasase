# destination_table: executivo_federal_dou.artigos_classificados

SELECT relevancia, identifica, secao, edicao, pagina, data_pub, orgao, ementa, resumo, fulltext, assina, cargo, url, url_certificado, CURRENT_DATETIME('-03') AS data_registro 
FROM `gabinete-compartilhado.executivo_federal_dou.sheets_classificacao_cleaned`
WHERE url NOT IN (SELECT url FROM `gabinete-compartilhado.executivo_federal_dou.artigos_classificados`)