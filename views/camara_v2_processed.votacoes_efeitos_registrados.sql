/***
 Tabela de efeitos registrados das votações. Trata-se de um unnest do campo 
 "efeitosRegistrados" da tabela de detalhes sobre as votações (votacoes_detalhes).
 As informações únicas por linha do votacoes_detalhes foram repetidas aqui (ou seja,
 as que não estão em outros nested).
 
 -- Parseamos as datas, sendo que as em branco viraram null;
 -- Incluímos uma nova coluna 'n_efeitos' com a contagem de nested elementos em
    efeitosRegistrados.
 ***/

SELECT 

  -- Id único da votação:
  v.id AS id_votacao,
  
  v.idOrgao AS id_orgao,
  v.siglaOrgao AS sigla_orgao,
  v.idEvento AS id_evento,
  
  -- Data manualmente definida para a tramitação resultante de uma votação:
  PARSE_DATE("%Y-%m-%d", v.data) AS data_tramitacao_resultante,
  -- Data e horário de registro da tramitação no sistema que entrou em funcionamento em 2003:
  IF(LENGTH(v.dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", v.dataHoraRegistro)) AS data_tramitacao_registro,
  -- Data da última abertura de votação registrada nas tramitações antes da tramitação em questão (resultante de votação):
  IF(LENGTH(v.dataHoraUltimaAberturaVotacao) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", v.dataHoraUltimaAberturaVotacao)) AS data_abertura_votacao,
  
  -- Resultado:
  v.descUltimaAberturaVotacao AS descricao_abertura_votacao,
  descricao AS descricao_resultado, 
  aprovacao, 

  -- Informação sobre a última proposição apresentada antes da tramitação em questão (resultante da votação):
  IF(LENGTH(ultimaApresentacaoProposicao.dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", ultimaApresentacaoProposicao.dataHoraRegistro)) AS data_ultima_apresentacao,
  ultimaApresentacaoProposicao.descricao AS descricao_ultima_apresentacao, 

  -- URIs:
  uri AS uri_votacao,
  uriOrgao AS uri_orgao,
  uriEvento AS uri_evento,
  ultimaApresentacaoProposicao.uriProposicaoCitada AS uri_ultima_proposicao_citada,

  -- EFEITOS REGISTRADOS --

  IF(LENGTH(e.dataHoraResultado) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M", e.dataHoraResultado)) AS data_efeito,
  e.descResultado AS descricao_efeito,
  
  -- Info do último registro de abertura de votação nas tramitações:
  IF(LENGTH(e.dataHoraUltimaAberturaVotacao) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M", e.dataHoraUltimaAberturaVotacao)) AS data_abertura_votacao_efeito, 
  e.descUltimaAberturaVotacao AS descricao_abertura_votacao_efeito, 

  -- Info do último registro de apresentação de proposições:
  IF(LENGTH(e.dataHoraUltimaApresentacaoProposicao) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M", e.dataHoraUltimaApresentacaoProposicao)) AS data_ultima_apresentacao_efeito,
  e.descUltimaApresentacaoProposicao AS descricao_ultima_apresentacao_efeito, 

  -- Info da proposição principal, ao qual a proposição citada de dirige:
  e.tituloProposicao AS proposicao_principal, 
  e.uriProposicao AS uri_proposicao_principal, 

  -- Info da proposição citada, supostamente:
  e.tituloProposicaoCitada AS proposicao_citada, 
  e.uriProposicaoCitada As uri_proposicao_citada,

  ARRAY_LENGTH(v.efeitosRegistrados) AS n_efeitos,
  -- FIM DOS EFEITOS REGISTRADOS --

  -- Info da captura:
  api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.votacoes_detalhes` AS v, UNNEST(v.efeitosRegistrados) AS e