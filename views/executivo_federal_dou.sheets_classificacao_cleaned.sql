/*** 
     Seleciona das tabelas de classificação diária de artigos do DOU aquelas 
     efetivamente classificadas, ajusta alguns campos para ter compatibilidade
     entre as tabelas de cada seção e agrega todas as seções.
 ***/

SELECT relevancia, identifica, secao, CAST(edicao AS STRING) AS edicao, pagina, FORMAT_DATE('%Y-%m-%d', data_pub) AS data_pub, orgao, ementa, resumo, fulltext, assina, cargo, url, url_certificado 
FROM `gabinete-compartilhado.executivo_federal_dou.sheets_classificacao_secao_1`
WHERE relevancia IS NOT NULL

UNION ALL

SELECT relevancia, identifica, secao, CAST(edicao AS STRING) AS edicao, pagina, FORMAT_DATE('%Y-%m-%d', data_pub), orgao, ementa, resumo, fulltext, assina, cargo, url, url_certificado 
FROM `gabinete-compartilhado.executivo_federal_dou.sheets_classificacao_secao_2`
WHERE relevancia IS NOT NULL

UNION ALL 

SELECT relevancia, identifica, secao, CAST(edicao AS STRING) AS edicao, pagina, FORMAT_DATE('%Y-%m-%d', data_pub) AS data_pub, orgao, ementa, resumo, fulltext, assina, cargo, url, url_certificado 
FROM `gabinete-compartilhado.executivo_federal_dou.sheets_classificacao_secao_3`
WHERE relevancia IS NOT NULL

UNION ALL

SELECT relevancia, identifica, secao, edicao, pagina, FORMAT_DATE('%Y-%m-%d', data_pub) AS data_pub, orgao, ementa, resumo, fulltext, assina, cargo, url, url_certificado 
FROM `gabinete-compartilhado.executivo_federal_dou.sheets_classificacao_secao_e`
WHERE relevancia IS NOT NULL