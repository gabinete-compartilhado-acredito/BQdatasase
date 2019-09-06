SELECT  
CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[ORDINAL(2)] AS INT64) as id_deputado,
PARSE_DATETIME("%Y-%m-%d", SPLIT(dataInicio , 'T')[ordinal(1)] ) AS data_inicio,
PARSE_DATETIME("%Y-%m-%d", SPLIT(dataFim, 'T')[ordinal(1)] ) AS data_fim,
idOrgao AS id_orgao,
nomeOrgao As nome_orgao,
siglaOrgao AS sigla_orgao,
titulo,
CASE
WHEN siglaOrgao LIKE 'PEC%' THEN 'PEC'
WHEN siglaOrgao LIKE 'CPI%' THEN 'CPI' 
WHEN siglaOrgao LIKE 'SUB%' THEN 'SubComissao' 
WHEN siglaOrgao LIKE 'CEX%' THEN 'Comissao Externa' 
WHEN siglaOrgao LIKE 'PL%' THEN 'Comissao Especial PL' 
WHEN siglaOrgao LIKE 'PEC%' THEN 'Comissao Especial PEC' 
WHEN siglaOrgao LIKE 'GT%' THEN 'Grupo de Trabalho' 
WHEN ((siglaOrgao LIKE 'CPM%') OR (siglaOrgao LIKE 'CM%')) AND (siglaOrgao NOT IN ('CMADS', 'CME') AND siglaOrgao NOT LIKE 'CMO%') THEN 'Comissao Parlamentar Mista' 
WHEN ((siglaOrgao LIKE 'CE%') AND (siglaOrgao != 'CE')) OR (siglaOrgao = 'REFPREVI') OR (siglaOrgao LIKE 'RE%') THEN 'Comissao Especial' 
WHEN siglaOrgao LIKE 'OUVIDOR%' THEN 'Ouvidoria' 
WHEN siglaOrgao LIKE 'CMO%' THEN 'Comissão Mista de Orcamento' 
WHEN siglaOrgao LIKE 'BAN%' THEN 'Bancada' 
WHEN siglaOrgao LIKE 'REP%' THEN 'Comissão Representativa do Congresso Nacional' 
WHEN siglaOrgao IN ('PARLAJOV', 'CRISE-CO', 'CRISE-IN', 
                     'CRISE-AG', 'CRISE-SF', 'MSC18304', 'MERCOSUL',
                     'REFPOLIT', 'PARJOV10', 'PROPAR', 'PRMULHER', 
                     'ALTOSE03', 'PROC1999', 'PARLAJ13', 'CDMULHER',
                     'SINCOMBU', 'ALTOSEST', 'PARLA17', 'MERCOSUL-A',
                     'CRISE-SE') THEN 'Outros'
WHEN siglaOrgao = 'MESA' THEN 'Mesa'
WHEN siglaOrgao IN ('CCJC', 'CMO', 'CFT') THEN 'Classe A'
WHEN siglaOrgao IN ('CE', 'CTASP', 'CINDRA', 'CREDN',
                    'CSSF', 'CCTCI', 'CVT', 'CMADS', 'CSPCCO',
                    'CME', 'CAPADR', 'CDC', 'CDEICS') THEN 'Classe B'
ELSE 'Classe C'
END as tipo
FROM `gabinete-compartilhado.camara_v2.deputados_orgaos` 