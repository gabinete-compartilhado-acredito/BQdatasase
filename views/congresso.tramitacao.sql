SELECT DISTINCT
 'camara' as casa,
  -- Informação sobre a proposição:
  CAST(ARRAY_REVERSE(SPLIT(t1.api_url, '/'))[ORDINAL(2)] AS INT64) AS id,
  t2.sigla_tipo as sigla_tipo,
  t2.numero,
  t2.ano,
  -- Informação sobre a tramitação:
  PARSE_DATETIME('%Y-%m-%dT%H:%M', t1.dataHora) as data_hora,
  t1.sequencia,
  t1.siglaOrgao as sigla_orgao,
  t1.uriOrgao as uri_orgao,
  t1.codSituacao as cod_situacao,
  t1.regime as regime,
  t1.descricaoTramitacao as descricao_tramitacao,
  t1.codTipoTramitacao as cod_tipo_tramitacao,
  t1.descricaoSituacao as descricao_situacao,
  t1.despacho,
  -- Informação sobre a proposição:
  t2.ementa,
  -- Informações sobre o autor da proposição:
  t2.nome_autor,
  t2.sigla_partido_autor,
  t2.sigla_uf_autor,
  -- Informação sobre a proposição:
  LOWER(t2.keywords) as keywords,
  t1.url

FROM `gabinete-compartilhado.camara_v2.tramitacoes` AS t1
LEFT JOIN `gabinete-compartilhado.congresso.proposicoes` AS t2
ON CAST(ARRAY_REVERSE(SPLIT(t1.api_url, '/'))[ORDINAL(2)] AS INT64) = t2.id
