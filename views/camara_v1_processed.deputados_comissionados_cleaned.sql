SELECT  
  -- Informações do deputado:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[OFFSET(1)] AS INT64) AS id_deputado,
  -- Cargo do comissionado:
  TRIM(nome) AS nome, TRIM(grupo_funcional) AS grupo_funcional,
  TRIM(folha_categoria_funcional) AS folha_categoria_funcional, -- 'folha' indica dados obtidos na segunda captura, da folha de remuneração.
  TRIM(folha_cargo) AS  folha_cargo, 
  TRIM(cargoXfuncao) AS cargo_v1,
  TRIM(cargo) AS cargo_v2,
  TRIM(IFNULL(cargoXfuncao, cargo)) AS cargo, -- Unifica sigla dos cargos de diferentes capturas numa única coluna.
  TRIM(folha_funcaoXcargo_comissao) AS folha_cargo_comissao,
  -- Datas:
  TRIM(periodo_exercicio) AS periodo_exercicio,
  PARSE_DATE('%d/%m/%Y', SPLIT(TRIM(periodo_exercicio), ' ')[ORDINAL(2)]) AS data_comeco,
  IF(REGEXP_CONTAINS(periodo_exercicio, r"\d{1,2}/\d{1,2}/\d{2,4}.+\d{1,2}/\d{1,2}/\d{2,4}"), 
     PARSE_DATE('%d/%m/%Y', ARRAY_REVERSE(SPLIT(TRIM(periodo_exercicio), ' '))[ORDINAL(1)]), NULL) AS data_termino,
  data AS data_ref_original,
  IF(REGEXP_CONTAINS(data, '/'), PARSE_DATE('%m/%Y', data), PARSE_DATE('%m%Y', data)) AS data_referencia,
  PARSE_DATE('%d/%m/%Y', TRIM(folha_data_exercicio)) AS folha_data_exercicio, -- Talvez indique primeira data do comissionado na câmara, mesmo que em outro gabinete.
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
  TRIM(remuneracao_mensal) AS link_remuneracao,
  comissionado_url,
  api_url,
  capture_date

FROM `gabinete-compartilhado.camara_v1.deputados_comissionados`