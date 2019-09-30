-- Limpa a tabela 'orgaos' (parseia datas, remove coluna vazia) --

-- Esta tabela dá mais informações sobre um órgão (e.g. comissão).

SELECT  
  -- Identificação do órgão:
  CAST(ARRAY_REVERSE(SPLIT(uri, '/'))[OFFSET(0)] AS INT64) AS id_orgao,
  sigla,
  apelido,
  nome,
  -- Info do orgão:
  codTipoOrgao AS cod_tipo_orgao,
  tipoOrgao AS tipo_orgao,
  casa,
  sala, -- Sala onde ficam as secretárias, etc.
  -- Status do órgão:
  codSituacao AS cod_situacao,
  descricaoSituacao AS descricao_situacao,
  IF(CHAR_LENGTH(dataInicio)<1, NULL, PARSE_DATETIME('%Y-%m-%dT%H:%M:%S', dataInicio)) AS data_inicio,
  IF(CHAR_LENGTH(dataInstalacao)<1, NULL, PARSE_DATETIME('%Y-%m-%dT%H:%M:%S', dataInstalacao)) AS data_instalacao,
  IF(CHAR_LENGTH(dataFim)<1, NULL, PARSE_DATETIME('%Y-%m-%dT%H:%M:%S', dataFim)) AS data_fim,
  -- Links:
  -- urlWebsite é sempre vazio.
  uri,
  -- Info da captura:
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,
  api_url

FROM `gabinete-compartilhado.camara_v2.orgaos`