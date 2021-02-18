/***
 Tabela de votações (incluindo as em comissões) dos Dados Abertos da Câmara. 
 As informações dessas votações foram extraídas pelos Dados Abertos a partir
 dos dados de tramitações. As limpezas que fizemos:
 
 -- Parseamos as datas, sendo que as em branco se tornaram null;
 -- Campos em branco foram transformados em null.
 ***/

SELECT

  -- Identificadores da votação e contexto:
  id AS id_votacao,
  idOrgao AS id_orgao,
  siglaOrgao AS sigla_orgao,
  idEvento AS id_evento,
  -- Data manualmente definida para a tramitação resultante de uma votação:
  PARSE_DATE("%Y-%m-%d", data) AS data_tramitacao_resultante,
  -- Data e horário de registro da tramitação no sistema que entrou em funcionamento em 2003:
  IF(LENGTH(dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", dataHoraRegistro)) AS data_tramitacao_registro,
  -- Data da última abertura de votação registrada nas tramitações antes da tramitação em questão (resultante de votação):
  IF(LENGTH(ultimaAberturaVotacao.dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", ultimaAberturaVotacao.dataHoraRegistro)) AS data_abertura_votacao,
  
  -- Resultado:
  IF(LENGTH(ultimaAberturaVotacao.descricao) = 0, NULL, TRIM(ultimaAberturaVotacao.descricao)) AS descricao_abertura_votacao,
  descricao AS descricao_resultado, 
  aprovacao, 
  votosSim AS votos_sim,
  votosNao AS votos_nao, 
  votosOutros AS votos_outros,

  -- Informação sobre a última proposição apresentada antes da tramitação em questão (resultante da votação):
  IF(LENGTH(ultimaApresentacaoProposicao.dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", ultimaApresentacaoProposicao.dataHoraRegistro)) AS data_ultima_apresentacao,
  IF(LENGTH(ultimaApresentacaoProposicao.descricao) = 0, NULL, TRIM(ultimaApresentacaoProposicao.descricao)) AS descricao_ultima_apresentacao, 
  ultimaApresentacaoProposicao.idProposicao AS id_ultima_proposicao_apresentada,

  -- URIs:
  uri AS uri_votacao,
  uriOrgao AS uri_orgao,
  uriEvento AS uri_evento,
  ultimaApresentacaoProposicao.uriProposicao AS uri_ultima_proposicao_apresentada,
  
  -- Info da captura:
  api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.votacoes`