SELECT 
  contratada, n_processo, tipo_contrato, tipo_processo, 
  data_ateste, data_pagamento, n_empenho, tipo_rubrica, ptres, ordem_bancaria, justificativa, tema, idn_nota_fiscal, n_nota_fiscal, 
  valor_bruto_contratada, valor_liquido_contratada, 
  veiculo_fornecedor,
  -- CNPJ do veículo:
  SPLIT(veiculo_fornecedor, ' / ')[OFFSET(0)] AS cnpj_veiculo_formatado,
  TRIM(REGEXP_REPLACE(SPLIT(veiculo_fornecedor, ' / ')[OFFSET(0)], r'[./\-]', '')) AS cnpj_veiculo,
  SPLIT(veiculo_fornecedor, ' / ')[OFFSET(1)] AS nome_veiculo,

  valor_bruto_fornecedor, valor_liquido_fornecedor, 
  nome_fantasia_veiculo, grupo_editora, 
  meios, tipo_praca_veiculacao, pracas_veiculacao,
  -- Município de veiculação:
  IF(tipo_praca_veiculacao = 'Regional', SPLIT(pracas_veiculacao, ' - ')[OFFSET(0)], NULL) AS municipio_veiculacao,
  -- UF de veiculação:
  CASE pracas_veiculacao
    WHEN 'DISTRITO FEDERAL' THEN 'DF'
    WHEN 'ALAGOAS' THEN 'AL'
    WHEN 'AMAPA' THEN 'AP'
    WHEN 'RORAIMA' THEN 'RR'
    ELSE SPLIT(pracas_veiculacao, ' - ')[SAFE_OFFSET(1)]
  END AS uf_veiculacao

FROM `gabinete-compartilhado.executivo_federal_outros.campanha_cuidado_precoce`