/***
 Tabela de proposições afetadas pelas votações. Trata-se de um unnest do campo 
 "proposicoesAfetadas" da tabela de detalhes sobre as votações (votacoes_detalhes).
 As informações únicas por linha do votacoes_detalhes foram repetidas aqui (ou seja,
 as que não estão em outros nested).
 
 -- Parseamos as datas, sendo que as em branco viraram null;
 -- Incluímos uma nova coluna 'n_afetadas' com a contagem de nested elementos em
    proposicoesAfetadas.
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
  TRIM(v.descUltimaAberturaVotacao) AS descricao_abertura_votacao,
  TRIM(v.descricao) AS descricao_resultado, 
  v.aprovacao, 

  -- Informação sobre a última proposição apresentada antes da tramitação em questão (resultante da votação):
  IF(LENGTH(v.ultimaApresentacaoProposicao.dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", v.ultimaApresentacaoProposicao.dataHoraRegistro)) AS data_ultima_apresentacao,
  TRIM(v.ultimaApresentacaoProposicao.descricao) AS descricao_ultima_apresentacao, 

  -- URIs:
  v.uri AS uri_votacao,
  v.uriOrgao AS uri_orgao,
  v.uriEvento AS uri_evento,
  v.ultimaApresentacaoProposicao.uriProposicaoCitada AS uri_ultima_proposicao_citada,

  -- PROPOSIÇÕES AFETADAS --
  
  a.id AS id_afetada,
  a.codTipo AS codTipo_afetada,
  a.siglaTipo AS siglaTipo_afetada,
  a.numero AS numero_afetada,
  a.ano AS ano_afetada, 
  a.ementa AS ementa_afetada, 
  a.uri AS uri_afetada,
  ARRAY_LENGTH(v.proposicoesAfetadas) AS n_afetadas,
  
  -- FIM DAS PROPOSIÇÕES AFETADAS --

  -- Info da captura:
  v.api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", v.capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.votacoes_detalhes` AS v, UNNEST(v.proposicoesAfetadas) AS a