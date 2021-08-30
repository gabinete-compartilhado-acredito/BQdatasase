SELECT UPPER(nome_socio) AS nome, 'Sócios' AS base, cnpj_cpf_socio AS cpf 
FROM `gabinete-compartilhado.receita_federal.socios_cleaned`

UNION ALL

SELECT UPPER(nome_candidato) AS nome, 'Candidatos' AS base, cpf_candidato_str AS cpf 
FROM `gabinete-compartilhado.tratado_tse_processed.consulta_candidatos_cleaned`

UNION ALL

SELECT UPPER(nome_doador_rfb_unico) AS nome, 'Doadores 2018' AS base, cpf_cnpj_doador_unico AS cpf 
FROM `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018`

UNION ALL

SELECT UPPER(nome_doador_rfb_unico) AS nome, 'Doadores 2014' AS base, cpfcnpj_doador_unico AS cpf 
FROM `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2014`

UNION ALL

SELECT UPPER(nome_beneficiario) AS nome, 'Aux. Emergencial Beneficiário' AS base, cpf_beneficiario AS cpf
FROM `gabinete-compartilhado.executivo_federal_outros.auxilio_emergencial` 

UNION ALL

SELECT UPPER(nome_responsavel) AS nome, 'Aux. Emergencial Responsável' AS base, cpf_responsavel AS cpf
FROM `gabinete-compartilhado.executivo_federal_outros.auxilio_emergencial` 

UNION ALL

SELECT UPPER(sc.nome) AS nome, 'Servidores Federais Civis' AS base, sc.cpf AS cpf
FROM `gabinete-compartilhado.executivo_federal_servidores.cadastro_civis` AS sc

UNION ALL

SELECT UPPER(sm.nome) AS nome, 'Servidores Federais Militares' AS base, sm.cpf AS cpf
FROM `gabinete-compartilhado.executivo_federal_servidores.cadastro_militares` AS sm

UNION ALL

SELECT UPPER(mr.NOME_SEM_ACENTO) AS nome, 'Militares Inativos RIC' AS base, mr.cpf AS cpf
FROM `gabinete-compartilhado.executivo_federal_servidores.militares_inativos_RIC` AS mr



