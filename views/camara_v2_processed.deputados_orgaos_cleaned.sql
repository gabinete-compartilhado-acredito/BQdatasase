/***
     Tabela limpa sobre a participação dos deputados em órgãos (comissões, conselhos, mesa, grupos de trabalho, 
     etc):
     - Nova coluna com id do deputado a partir da URL da API;
     - Datas parseadas;
 ***/

SELECT
  -- Id do deputado:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[ORDINAL(2)] AS INT64) AS id_deputado,
  -- Info do órgão:
  idOrgao AS id_orgao,
  siglaOrgao AS sigla_orgao,
  nomeOrgao AS nome_orgao,
  -- Info do cargo:
  codTitulo AS codigo_titulo,
  titulo,
  PARSE_DATETIME("%Y-%m-%dT%H:%M", dataInicio) AS data_inicio,
  PARSE_DATETIME("%Y-%m-%dT%H:%M", dataFim) AS data_fim,
  -- URLs:
  uriOrgao AS url_orgao,
  -- Info da captura:
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date,
  api_url
FROM `gabinete-compartilhado.camara_v2.deputados_orgaos`