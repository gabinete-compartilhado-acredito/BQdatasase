/***
     Limpando a tabela de sócios:
     - Passa as seguintes colunas para INT: tipo_socio, cod_qualificacao, cod_qualif_repres;
     - Acrescenta coluna que diz se cnpj_cpf_socio é CNPJ ou CPF. Essa informação já estava contida em tipo_socio;
     - Parseia data de entrada e corrige typos;
     - Substitui strings vazias por NULLs;
     - Substitui cpf_repres todo zero por NULL;
 ***/

SELECT
  cnpj,
  CAST(tipo_socio AS INT64) AS tipo_socio,
  nome_socio,
  cnpj_cpf_socio,
  IF(LENGTH(cnpj_cpf_socio) = 11, 'CPF', IF(LENGTH(cnpj_cpf_socio) = 14, 'CNPJ', 'DESCONHECIDO')) AS tipo_documento,
  CAST(cod_qualificacao AS INT64) AS cod_qualificacao,
  -- perc_capital é sempre 0, por questões de privacidade;
  PARSE_DATE('%Y%m%d', REGEXP_REPLACE(data_entrada, '^000(\\d){1}', '200\\1')) AS data_entrada,
  IF(LENGTH(cod_pais_ext) = 0, NULL, CAST(cod_pais_ext AS INT64)) AS cod_pais_ext,
  nome_pais_ext,
  IF(LENGTH( cpf_repres) = 0, NULL,  IF(cpf_repres = '00000000000', NULL, cpf_repres)) AS  cpf_repres,
  IF(LENGTH(nome_repres) = 0, NULL, nome_repres) AS nome_repres,
  CAST(cod_qualif_repres AS INT64) AS cod_qualif_repres

FROM `gabinete-compartilhado.receita_federal.socios`
