/***
 Tabela de proposições afetadas pelas votações. Trata-se de um unnest do campo 
 "objetosPossiveis" da tabela de detalhes sobre as votações (votacoes_detalhes).
 As informações únicas por linha do votacoes_detalhes foram repetidas aqui (ou seja,
 as que não estão em outros nested).
 
 -- Parseamos as datas, sendo que as em branco viraram null;
 -- Incluímos uma nova coluna 'n_obj_possiveis' com a contagem de nested elementos em
    objetosPossiveis.
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
  v.descricao AS descricao_resultado, 
  v.aprovacao, 

  -- Informação sobre a última proposição apresentada antes da tramitação em questão (resultante da votação):
  IF(LENGTH(v.ultimaApresentacaoProposicao.dataHoraRegistro) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", v.ultimaApresentacaoProposicao.dataHoraRegistro)) AS data_ultima_apresentacao,
  v.ultimaApresentacaoProposicao.descricao AS descricao_ultima_apresentacao, 

  -- URIs:
  v.uri AS uri_votacao,
  v.uriOrgao AS uri_orgao,
  v.uriEvento AS uri_evento,
  v.ultimaApresentacaoProposicao.uriProposicaoCitada AS uri_ultima_proposicao_citada,

  -- OBJETOS POSSÍVEIS --
  
  o.id AS id_obj_possivel,
  o.codTipo AS codTipo_obj_possivel,
  o.siglaTipo AS siglaTipo_obj_possivel,
  o.numero AS numero_obj_possivel,
  o.ano AS ano_obj_possivel, 
  o.ementa AS ementa_obj_possivel, 
  o.uri AS uri_obj_possivel,
  ARRAY_LENGTH(v.objetosPossiveis) AS n_obj_possiveis,
  
  -- FIM DOS OBJETOS POSSÍVEIS --

  -- Info da captura:
  v.api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", v.capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.votacoes_detalhes` AS v, UNNEST(v.objetosPossiveis) AS o