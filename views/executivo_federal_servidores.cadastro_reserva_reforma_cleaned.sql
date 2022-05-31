/***
    Limpeza dos dados sobre militares reformados (aposentados)
    e da reserva (que ainda podem ser convocados em algum caso de
    guerra).
    -- Parseamos datas;
    -- Parseamos alguns inteiros, mas não todos.
 ***/

SELECT 
    -- Época:
    CAST(mes AS INT64) AS mes, 
    CAST(ano AS INT64) AS ano,
    -- Id do servidor: 
    CAST(id_servidor AS INT64) AS id_servidor, 
    nome, 
    cpf, 
    matricula,
    -- Outros: 
    cod_tipo_aposentadoria, 
    tipo_aposentadoria, 
    PARSE_DATE('%d/%m/%Y', data_aposentadoria) AS data_aposentadoria, 
    desc_cargo, 
    cod_uorg_lotacao, 
    uorg_lotacao, 
    cod_org_lotacao, 
    org_lotacao, 
    orgsup_lotacao, 
    cod_tipo_vinculo, 
    tipo_vinculo, 
    situacao_vinculo, 
    regime_juridico, 
    jornada_de_trabalho, 
    PARSE_DATE('%d/%m/%Y', ingresso_cargo_funcao) AS ingresso_cargo_funcao, 
    nomeacao_cargo_funcao, 
    ingresso_orgao, 
    doc_ingresso_servico_publico, 
    data_dipl_ingresso_servico_publico, 
    dipl_ingresso_cargo_funcao, 
    dipl_ingresso_orgao, 
    dipl_ingresso_servico_publico, 
    -- Partição:
    data
FROM `gabinete-compartilhado.executivo_federal_servidores.cadastro_reserva_reforma`