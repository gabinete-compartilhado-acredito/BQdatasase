/*** 
    Tabela limpa de receitas de campanha de candidatos nas eleições de 2014 
    - Parseamos datas;
    - Mudamos algumas variáveis para inteiro ou float.
 ***/

SELECT 
CAST(cod_eleicao AS INT64) AS cod_eleicao, 
desc_eleicao, 
PARSE_DATETIME('%d/%m/%Y%H:%M:%S', data_hora) AS data_hora, 
cnpj_prestador_conta, 
CAST(sequencial_candidato AS INT64) AS sequencial_candidato, 
uf, 
sigla_partido, 
CAST(numero_candidato AS INT64) AS numero_candidato, 
cargo, 
nome_candidato, 
cpf_candidato, 
numero_recibo_eleitoral, 
numero_documento, 
cpfcnpj_doador, 
nome_doador, 
nome_doador_receita_federal, 
sigla_ue_doador, 
CAST(numero_partido_doador AS INT64) AS numero_partido_doador, 
CAST(numero_candidato_doador AS INT64) AS numero_candidato_doador, 
cod_setor_economico_doador AS cnae_doador, 
setor_economico_doador denom_cnae_doador, 
PARSE_DATE('%d/%m/%Y', REPLACE(data_receita, '00:00:00', '')) AS data_receita, 
CAST(valor_receita AS FLOAT64) AS valor_receita, 
tipo_receita AS origem_receita, 
fonte_recurso, 
especie_recurso, 
descricao_receita, 
nome_doador_originario,
nome_doador_originario_receita_federal AS nome_doador_originario_rfb,
cpfcnpj_doador_originario, 
tipo_doador_originario, 
setor_economico_doador_originario

FROM `gabinete-compartilhado.tratado_tse.receitas_candidatos_2014` 