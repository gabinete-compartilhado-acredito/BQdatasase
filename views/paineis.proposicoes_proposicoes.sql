SELECT
    id,
    PARSE_DATETIME("%Y-%m-%d", SPLIT(dataApresentacao, 'T')[ordinal(1)] ) AS data_apresentacao,
    siglaTipo AS sigla_tipo,
    numero,
    ano,
    descricaoTipo AS descricao_tipo,
    ementa,
    keywords,
    urlInteiroTeor AS url_inteiro_teor,
    ementaDetalhada AS ementa_detalhada
FROM
   `gabinete-compartilhado.camara_v2.proposicoes`