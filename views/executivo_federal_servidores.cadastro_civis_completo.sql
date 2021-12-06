/***
 Junta as duas versões de dados sobre servidores federais civis.
 A v1 cobre o período de jan/2013 a jan/2021, e a v2
 cobre o período de fev/2021 em diante. As colunas são as da v2,
 sendo que a coluna 'tipo_vinculo' da v1 foi chamada de 'cod_tipo_vinculo'
 e foi criada uma coluna vazia para 'tipo_vinculo' no lugar, de maneira
 a padronizar o conteúdo das colunas das versões v1 e v2.
 ***/

-- Servidores cadastrados no SIAPE, estrutura dos dados v2:
SELECT 
    mes, ano, id_servidor, nome, cpf, matricula, desc_cargo, classe_cargo, ref_cargo, padrao_cargo, nivel_cargo, 
    sigla_funcao, nivel_funcao, funcao, cod_atividade, atividade, opcao_parcial, cod_uorg_lotacao, uorg_lotacao,
    cod_org_lotacao, org_lotacao, cod_orgsup_lotacao, orgsup_lotacao, cod_uorg_exercicio, uorg_exercicio, cod_org_exercicio,
    org_exercicio, cod_orgsup_exercicio,
    orgsup_exercicio, cod_tipo_vinculo, tipo_vinculo, situacao_vinculo, inicio_afastamento, termino_afastamento,
    regime_juridico, jornada_de_trabalho, ingresso_cargo_funcao, nomeacao_cargo_funcao, ingresso_orgao,
    doc_ingresso_servico_publico, data_dipl_ingresso_servico_publico, dipl_ingresso_cargo_funcao, dipl_ingresso_orgao,
    dipl_ingresso_servico_publico, uf_exercicio, data
FROM `gabinete-compartilhado.executivo_federal_servidores.v2_cadastro_siape`

UNION ALL

-- Servidores cadastrados no BACEN, estrutura dos dados v2:
SELECT 
    mes, ano, id_servidor, nome, cpf, matricula, desc_cargo, classe_cargo, ref_cargo, padrao_cargo, nivel_cargo, 
    sigla_funcao, nivel_funcao, funcao, cod_atividade, atividade, opcao_parcial, cod_uorg_lotacao, uorg_lotacao,
    cod_org_lotacao, org_lotacao, cod_orgsup_lotacao, orgsup_lotacao, cod_uorg_exercicio, uorg_exercicio, cod_org_exercicio,
    org_exercicio, cod_orgsup_exercicio,
    orgsup_exercicio, cod_tipo_vinculo, tipo_vinculo, situacao_vinculo, inicio_afastamento, termino_afastamento,
    regime_juridico, jornada_de_trabalho, ingresso_cargo_funcao, nomeacao_cargo_funcao, ingresso_orgao,
    doc_ingresso_servico_publico, data_dipl_ingresso_servico_publico, dipl_ingresso_cargo_funcao, dipl_ingresso_orgao,
    dipl_ingresso_servico_publico, uf_exercicio, data
FROM `gabinete-compartilhado.executivo_federal_servidores.v2_cadastro_bacen`

UNION ALL

-- Servidores cadastrados no SIAPE e BACEN, estrutura dos dados v1:
SELECT 
    mes, ano, id_servidor, nome, cpf, matricula, desc_cargo, classe_cargo, ref_cargo, padrao_cargo, nivel_cargo, 
    sigla_funcao, nivel_funcao, funcao, cod_atividade, atividade, opcao_parcial, cod_uorg_lotacao, uorg_lotacao,
    cod_org_lotacao, org_lotacao, cod_orgsup_lotacao, orgsup_lotacao, cod_uorg_exercicio, uorg_exercicio, cod_org_exercicio,
    org_exercicio, cod_orgsup_exercicio,
    orgsup_exercicio, tipo_vinculo AS cod_tipo_vinculo, NULL AS tipo_vinculo, situacao_vinculo, inicio_afastamento, termino_afastamento,
    regime_juridico, jornada_de_trabalho, ingresso_cargo_funcao, nomeacao_cargo_funcao, ingresso_orgao,
    doc_ingresso_servico_publico, data_dipl_ingresso_servico_publico, dipl_ingresso_cargo_funcao, dipl_ingresso_orgao,
    dipl_ingresso_servico_publico, uf_exercicio, data
FROM `gabinete-compartilhado.executivo_federal_servidores.cadastro_civis`
