/***
     Tabela de tramitações limpa:
     -- Nova coluna com id da proposição;
     -- Data de tramitação e captura em DATETIME (bug 'M' em %M no capture_date arranjado);
     -- Remoção de duplicatas completas.
***/

SELECT DISTINCT
  CAST(ARRAY_REVERSE(SPLIT(api_url,"/"))[ORDINAL(2)] AS INT64) AS id_proposicao,
  codSituacao,
  codTipoTramitacao,
  PARSE_DATETIME("%Y-%m-%dT%H:%M", dataHora) AS data_hora,
  descricaoSituacao,
  descricaoTramitacao,
  despacho,
  regime,
  sequencia,
  siglaOrgao,
  uriOrgao,
  url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", REPLACE(capture_date, "M", "30")) AS capture_date,
  api_url
FROM `gabinete-compartilhado.camara_v2.tramitacoes`

