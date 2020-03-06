/***
     Tabela limpa de proposições do senado.
     - Removeu colunas sempre vazias;
     - Parseou data de captura;
     - Deu trim em campos de texto;
     - Expandiu structs.
 ***/

SELECT  
  --Id da proposição:
  IdentificacaoMateria.CodigoMateria AS Codigo_Materia,
  IdentificacaoMateria.DescricaoIdentificacaoMateria AS Descricao_Identificacao_Materia,
  IdentificacaoMateria.DescricaoObjetivoProcesso AS Descricao_Objetivo_Processo,
  IdentificacaoMateria.DescricaoSubtipoMateria AS Descricao_Subtipo_Materia,
  IdentificacaoMateria.AnoMateria AS Ano_Materia,
  IdentificacaoMateria.IndicadorTramitando AS Indicador_Tramitando,
  IdentificacaoMateria.NomeCasaIdentificacaoMateria AS Nome_Casa_Identificacao_Materia,
  IdentificacaoMateria.NumeroMateria AS Numero_Materia,
  IdentificacaoMateria.SiglaCasaIdentificacaoMateria AS Sigla_Casa_Identificacao_Materia,
  IdentificacaoMateria.SiglaComissaoRequerimento AS Sigla_Comissao_Requerimento,
  IdentificacaoMateria.SiglaSubtipoMateria AS Sigla_Subtipo_Materia,
  
  -- Assunto da proposição:
  Assunto.AssuntoEspecifico.Codigo AS Assunto_Especifico_Codigo,
  Assunto.AssuntoEspecifico.Descricao AS Assunto_Especifico_Descricao,
  Assunto.AssuntoGeral.Codigo AS Assunto_Geral_Codigo,
  Assunto.AssuntoGeral.Descricao AS Assunto_Geral_Descricao,
  
  -- Status da proposição:
  --AtualizacoesRecentes.Atualizacao.DataUltimaAtualizacao AS Data_Ultima_Atualizacao, -- Sempre vazias.
  --AtualizacoesRecentes.Atualizacao.InformacaoAtualizada AS Informacao_Atualizada,    -- Sempre vazias.
  
  -- Autores:
  Autoria.Autor AS Autoria,
  -- AutoresPrincipais.AutorPrincipal -- Sempre vazia.
  
  -- Origem (autoria) da matéria:
  OrigemMateria.NomePoderOrigem AS Nome_Poder_Origem,
  OrigemMateria.SiglaCasaOrigem AS Sigla_Casa_Origem,
  OrigemMateria.NomeCasaOrigem AS Nome_Casa_Origem,
  
  -- Casa iniciadora:
  CasaIniciadoraNoLegislativo.NomeCasaIniciadora AS Casa_Iniciadora_legislativo,
  CasaIniciadoraNoLegislativo.SiglaCasaIniciadora AS Sigla_Casa_Iniciadora,
  
  -- Info da matéria:
  TRIM(DadosBasicosMateria.ApelidoMateria) AS Apelido_Materia, 
  DadosBasicosMateria.DataApresentacao AS Data_Apresentacao, 
  DadosBasicosMateria.DataAssinatura AS Data_Assinatura,
  DadosBasicosMateria.DataLeitura AS Data_Leitura, 
  TRIM(DadosBasicosMateria.EmentaMateria) AS Ementa_Materia, 
  TRIM(DadosBasicosMateria.ExplicacaoEmentaMateria) AS Explicacao_Ementa_Materia, 
  TRIM(DadosBasicosMateria.IndexacaoMateria) AS Indexacao_Materia,
  DadosBasicosMateria.IndicadorComplementar AS Indicador_Complementar,
  DadosBasicosMateria.NaturezaMateria.CodigoNatureza AS Codigo_Natureza,
  TRIM(DadosBasicosMateria.NaturezaMateria.DescricaoNatureza) AS Descricao_Natureza,
  DadosBasicosMateria.NaturezaMateria.NomeNatureza AS Nome_Natureza,
  DadosBasicosMateria.SiglaCasaLeitura AS Sigla_Casa_Leitura,
  DadosBasicosMateria.NomeCasaLeitura AS Nome_Casa_Leitura,
  TRIM(DadosBasicosMateria.ObservacaoMateria) AS Observacao_Materia,
  DadosBasicosMateria.ResultadoMateria AS Resultado_Materia,
  
  -- Dados no caso de medida provisória (MPV):
  DadosBasicosMateria.IdentificacaoComissaoMpv.SiglaCasaComissao AS mpv_Sigla_Casa,
  TRIM(DadosBasicosMateria.IdentificacaoComissaoMpv.NomeCasaComissao) AS mpv_Nome_Casa,
  DadosBasicosMateria.IdentificacaoComissaoMpv.CodigoComissao AS mpv_Codigo_Comissao, 
  DadosBasicosMateria.IdentificacaoComissaoMpv.SiglaComissao AS mpv_Sigla_Comissao,
  TRIM(DadosBasicosMateria.IdentificacaoComissaoMpv.NomeComissao) AS mpv_Nome_Comissao,
  DadosBasicosMateria.NumeroRepublicacaoMpv AS mpv_Numero_Republicacao,

  -- Matérias associadas:
  MateriasAnexadas.MateriaAnexada AS Materia_Anexada,
  MateriasAnexadas.MateriaPrincipal AS Materia_Principal,
  MateriasRelacionadas.MateriaRelacionada AS Materia_Relacionada,
  
  -- Autuações (tramitação):
  SituacaoAtual.Autuacoes.Autuacao AS Autuacao,

  -- Documentos relacionados (e.g. emendas, atas, relatórios)
  OutrasInformacoes.Servico AS Outras_Info_Servico,
  -- Outras identificações dessa matéria:
  OutrosNumerosDaMateria.OutroNumeroDaMateria AS Outro_Numero_Materia,
  
  -- Norma gerada: (organizar a ordem)
  NormaGerada.IdentificacaoNorma.CodigoNorma AS Codigo_norma,
  NormaGerada.IdentificacaoNorma.SiglaTipoNorma AS Sigla_Tipo_Norma,
  NormaGerada.IdentificacaoNorma.DescricaoTipoNorma AS Desc_Tipo_Norma,
  NormaGerada.IdentificacaoNorma.NumeroNorma AS Numero_Norma,
  NormaGerada.IdentificacaoNorma.AnoNorma AS Ano_Norma,
  NormaGerada.IdentificacaoNorma.DataNorma AS Data_norma,
  NormaGerada.IdentificacaoNorma.SiglaVeiculoPublicacao AS Sigla_Veiculo_Publicacao_Norma,
  NormaGerada.IdentificacaoNorma.DescricaoVeiculoPublicacao AS Desc_Veiculo_Publicacao_Norma,
  NormaGerada.IdentificacaoNorma.DataPublicacao AS Data_Publicacao_Norma,
  NormaGerada.IdentificacaoNorma.ObservacaoNorma AS Obersevacao_Norma,
  NormaGerada.IdentificacaoNorma.UrlNorma AS Url_Norma,
  
  -- Info da captura e referências:
  UrlGlossario AS Url_Glossario,
  api_url AS Api_Url,
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,

FROM `gabinete-compartilhado.senado.proposicoes`