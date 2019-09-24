SELECT  
  -- Informações do deputado:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[OFFSET(1)] AS INT64) AS id_deputado,
  -- Informações do comissionado:
  nome, grupo_funcional, cargoXfuncao,
  -- Datas:
  periodo_exercicio,
  PARSE_DATE('%d/%m/%Y', SPLIT(TRIM(periodo_exercicio), ' ')[ORDINAL(2)]) AS data_comeco,
  IF(REGEXP_CONTAINS(periodo_exercicio, r"\d{1,2}/\d{1,2}/\d{2,4}.+\d{1,2}/\d{1,2}/\d{2,4}"), 
     PARSE_DATE('%d/%m/%Y', ARRAY_REVERSE(SPLIT(TRIM(periodo_exercicio), ' '))[ORDINAL(1)]), NULL) AS data_termino,
  data AS data_ref_original,
  PARSE_DATE('%m/%Y', data) AS data_referencia,
  -- Remuneração:
  tipo AS tipo_folha,
  -- Remuneração básica:
  remuneracao_fixa, vantagens_natureza, 
  -- Remuneração eventual/provisória:
  funcao_cargo, gratificacao_natalina, ferias_1X3, outras_remuneracoes,
  -- Abono permanência:
  abono_permanencia,
  -- Descontos obrigatórios:
  redutor_constitucional, contribuicao_previdenciaria, imposto_renda,
  -- Remuneração após descontos obrigatórios:
  remuneracao_apos,
  -- Outros:
  diarias,
  auxilios,  
  vantagens_indenizatorias,
  -- Meus campos:
  remuneracao_apos - redutor_constitucional - contribuicao_previdenciaria - imposto_renda AS total_bruto,
  remuneracao_apos + diarias + auxilios + vantagens_indenizatorias AS total_liquido,
  -- Informações sobre a captura:
  comissionado_url,
  api_url,
  capture_date

FROM `gabinete-compartilhado.camara_v1.deputados_comissionados`