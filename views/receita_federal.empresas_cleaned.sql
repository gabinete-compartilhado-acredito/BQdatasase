SELECT
  -- CNPJ:
  cnpj,
  -- Matriz (1) ou filial (2):
  IF(LENGTH(matriz_filial     ) = 0, NULL, CAST(matriz_filial AS INT64)) AS matriz_filial,
  -- Nome da empresa:
  IF(LENGTH(razao_social      ) = 0, NULL, razao_social) AS razao_social,
  IF(LENGTH(nome_fantasia     ) = 0, NULL, nome_fantasia) AS nome_fantasia,
  -- Situação da empresa (01 - NULA; 02 - ATIVA; 03 - SUSPENSA; 04 - INAPTA; 08 - BAIXADA):
  IF(LENGTH(situacao          ) = 0, NULL, CAST(situacao AS INT64)) AS situacao,
  IF(LENGTH(data_situacao     ) = 0, NULL, IF(data_situacao = '00000000', NULL, PARSE_DATE('%Y%m%d', data_situacao))) AS data_situacao,
  IF(LENGTH(motivo_situacao   ) = 0, NULL, CAST(motivo_situacao AS INT64)) AS motivo_situacao,
  -- Localização no exterior:
  IF(LENGTH(nm_cidade_exterior) = 0, NULL, nm_cidade_exterior) AS nome_cidade_exterior,
  IF(LENGTH(cod_pais          ) = 0, NULL, cod_pais) AS cod_pais_str,
  IF(LENGTH(nome_pais         ) = 0, NULL, nome_pais) AS nome_pais,
  -- Tipo de empresa:
  IF(LENGTH(cod_nat_juridica  ) = 0, NULL, CAST(cod_nat_juridica AS INT64)) AS cod_nat_juridica,
  IF(LENGTH(data_inicio_ativ  ) = 0, NULL, IF(data_inicio_ativ = '00000000', NULL, PARSE_DATE('%Y%m%d', data_inicio_ativ))) AS data_inicio_ativ,
  IF(LENGTH(cnae_fiscal       ) = 0, NULL, cnae_fiscal) AS cnae_fiscal,
  IF(LENGTH(cnae_fiscal       ) = 0, NULL, CAST(cnae_fiscal AS INT64)) AS cnae_fiscal_int,
  -- Localização:
  IF(LENGTH(tipo_logradouro   ) = 0, NULL, tipo_logradouro) AS tipo_logradouro,
  IF(LENGTH(logradouro        ) = 0, NULL, logradouro) AS logradouro,
  IF(LENGTH(numero            ) = 0, NULL, numero) AS numero,
  IF(LENGTH(complemento       ) = 0, NULL, complemento) AS complemento,
  IF(LENGTH(bairro            ) = 0, NULL, bairro) AS bairro,
  IF(LENGTH(cep               ) = 0, NULL, cep) AS cep,
  IF(LENGTH(uf                ) = 0, NULL, uf) AS uf, 
  IF(LENGTH(cod_municipio     ) = 0, NULL, CAST(cod_municipio AS INT64)) AS cod_municipio,
  IF(LENGTH(municipio         ) = 0, NULL, municipio) AS municipio,
  -- Contato:
  IF(LENGTH(ddd_1             ) = 0, NULL, ddd_1) AS ddd_1,
  IF(LENGTH(telefone_1        ) = 0, NULL, telefone_1) AS telefone_1,
  IF(LENGTH(ddd_2             ) = 0, NULL, ddd_2) AS ddd_2,
  IF(LENGTH(telefone_2        ) = 0, NULL, telefone_2) AS telefone_2,
  IF(LENGTH(ddd_fax           ) = 0, NULL, ddd_fax) AS ddd_fax,
  IF(LENGTH(num_fax           ) = 0, NULL, num_fax) AS num_fax,
  IF(LENGTH(email             ) = 0, NULL, email) AS email,
  IF(LENGTH(qualif_resp       ) = 0, NULL, CAST(qualif_resp AS INT64)) AS qualif_resp,
  -- Tamanho da empresa:
  capital_social AS capital_social,
  IF(LENGTH(porte             ) = 0, NULL, CAST(porte AS INT64)) AS porte,
  IF(LENGTH(opc_simples       ) = 0, 0, CAST(opc_simples AS INT64)) AS opc_simples, -- De acordo com o layout dos dados, VAZIO equivale a 0.
  IF(LENGTH(data_opc_simples  ) = 0, NULL, IF(data_opc_simples = '00000000', NULL, PARSE_DATE('%Y%m%d', data_opc_simples))) AS data_opc_simples,
  IF(LENGTH(data_exc_simples  ) = 0, NULL, IF(data_exc_simples = '00000000', NULL, PARSE_DATE('%Y%m%d', data_exc_simples))) AS data_exc_simples,
  IF(LENGTH(opc_mei           ) = 0, NULL, opc_mei) AS opc_mei,
  IF(LENGTH(sit_especial      ) = 0, NULL, sit_especial) AS sit_especial,
  IF(LENGTH(data_sit_especial ) = 0, NULL, IF(data_sit_especial = '00000000', NULL, PARSE_DATE('%Y%m%d', data_sit_especial))) AS data_sit_especial,
FROM `gabinete-compartilhado.receita_federal.empresas` 