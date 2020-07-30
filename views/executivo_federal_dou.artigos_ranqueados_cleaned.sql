/***
     Limpa tabela de matérias do DOU classificadas automaticamente com ML
     em termos de relevância. 
     - Parseamos as datas.
 ***/

SELECT
  -- Predição da relevância da matéria:
  predicted_rank,
  -- Identificação:
  identifica,
  orgao,
  -- Conteúdo:
  ementa,
  resumo,
  fulltext,
  assina, 
  cargo,
  -- Dados de publicação:
  PARSE_DATE("%Y-%m-%d", data_pub) AS data_pub,
  secao,
  edicao,
  tipo_edicao,
  pagina,
  -- Links:
  url, 
  url_certificado,
  -- Datas de processamento:
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", process_date) AS process_date
  
FROM `gabinete-compartilhado.executivo_federal_dou.artigos_ranqueados_auto`