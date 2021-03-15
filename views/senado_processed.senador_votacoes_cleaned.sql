/***
    Tabela de votações dos senadores
    - Criei coluna de id do senador;
    - Renomeei e reordenei as colunas;
    - Parseei data de captura (demais datas já estavam em formato data).
 ***/

SELECT 
  -- Info da sessão: 
  SessaoPlenaria.CodigoSessao AS id_sessao, -- Identificador da sessão
  SessaoPlenaria.CodigoSessaoLegislativa AS id_sessao_legislativa, -- ?
  SessaoPlenaria.DataSessao AS data_sessao, 
  SessaoPlenaria.HoraInicioSessao AS hora_inicio_sessao,
  SessaoPlenaria.NomeCasaSessao AS nome_sasa_sessao, 
  SessaoPlenaria.SiglaCasaSessao AS sigla_casa_sessao,
  SessaoPlenaria.SiglaTipoSessao AS sigla_tipo_sessao,
  SessaoPlenaria.NumeroSessao AS num_sessao,
  -- Info da proposição:
  IdentificacaoMateria.CodigoMateria AS id_proposicao,
  IdentificacaoMateria.NomeCasaIdentificacaoMateria AS nome_casa_proposicao, -- Pode ser Senado ou Congresso (aparentemente, a base inclui votações do congresso).
  IdentificacaoMateria.SiglaCasaIdentificacaoMateria AS sigla_casa_proposicao,
  IdentificacaoMateria.SiglaSubtipoMateria AS sigla_tipo_proposicao,
  IdentificacaoMateria.DescricaoSubtipoMateria AS nome_tipo_proposicao,
  IdentificacaoMateria.NumeroMateria AS num_proposicao,
  IdentificacaoMateria.AnoMateria AS ano_proposicao,
  IdentificacaoMateria.DescricaoIdentificacaoMateria AS sig_num_ano_proposicao,
  IdentificacaoMateria.DescricaoObjetivoProcesso AS objetivo_processo, -- Revisão, Iniciadora, Emenda, Substitutivo... 
  IdentificacaoMateria.IndicadorTramitando AS tramitando,
  -- Info da votação:
  CodigoSessaoVotacao AS id_votacao,    -- Identificador único da votação.
  Sequencial AS num_sequencial_votacao, -- Número sequencial das votações ocorridas numa mesma sessão.
  IndicadorVotacaoSecreta AS votacao_secreta,
  DescricaoVotacao AS descricao_votacao, 
  DescricaoResultado AS resultado_votacao,
  TotalVotosSim AS n_votos_sim,
  TotalVotosNao AS n_votos_nao, 
  TotalVotosAbstencao AS n_votos_abstencao, 
  -- Info do voto do senador:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[OFFSET(1)] AS INT64) AS id_senador,
  SiglaDescricaoVoto AS sigla_voto,
  DescricaoVoto AS descricao_voto,
  -- Info da tramitação:
  Tramitacao.IdentificacaoTramitacao.CodigoTramitacao AS id_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.DataTramitacao AS data_tramitacao,
  Tramitacao.IdentificacaoTramitacao.NumeroOrdemTramitacao AS num_ordem_tramitacao,
  Tramitacao.IdentificacaoTramitacao.NumeroAutuacao AS num_autuacao, 
  Tramitacao.IdentificacaoTramitacao.Situacao.CodigoSituacao AS cod_situacao_tramitacao,
  Tramitacao.IdentificacaoTramitacao.Situacao.SiglaSituacao AS sigla_situacao_tramitacao,
  Tramitacao.IdentificacaoTramitacao.Situacao.DescricaoSituacao AS situacao_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.TextoTramitacao AS texto_tramitacao,
  -- Origem da tramitação:
  Tramitacao.IdentificacaoTramitacao.OrigemTramitacao.Local.CodigoLocal AS id_origem_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.OrigemTramitacao.Local.SiglaCasaLocal AS sigla_casa_origem_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.OrigemTramitacao.Local.NomeCasaLocal AS nome_casa_origem_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.OrigemTramitacao.Local.SiglaLocal AS sigla_origem_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.OrigemTramitacao.Local.NomeLocal AS nome_origem_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.OrigemTramitacao.Local.TipoLocal AS tipo_origem_tramitacao,  
  -- Destino da tramitação:
  Tramitacao.IdentificacaoTramitacao.DestinoTramitacao.Local.CodigoLocal AS id_destino_tramitacao,
  Tramitacao.IdentificacaoTramitacao.DestinoTramitacao.Local.SiglaCasaLocal AS sigla_casa_destino_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.DestinoTramitacao.Local.NomeCasaLocal AS nome_casa_destino_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.DestinoTramitacao.Local.SiglaLocal AS sigla_destino_tramitacao, 
  Tramitacao.IdentificacaoTramitacao.DestinoTramitacao.Local.NomeLocal AS nome_destino_tramitacao,
  Tramitacao.IdentificacaoTramitacao.DestinoTramitacao.Local.TipoLocal AS tipo_destino_tramitacao,
  -- Registro de recebimento da tramitação:
  Tramitacao.IdentificacaoTramitacao.IndicadorRecebimento AS recebido,
  Tramitacao.IdentificacaoTramitacao.DataRecebimento AS data_recebimento_tramitacao,  
  -- Info da captura:
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date,
  api_url
FROM `gabinete-compartilhado.senado.senador_votacoes`