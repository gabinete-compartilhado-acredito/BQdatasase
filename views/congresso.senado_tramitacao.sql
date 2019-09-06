SELECT
'senado' as casa,
t2.id,
t2.sigla_tipo,
t2.numero,
t2.ano,
datetime(timestamp(t1.capture_date), 'America/Sao_Paulo') as data_hora,
ROW_NUMBER() OVER(partition by id) as sequencia,
t1.IdentificacaoTramitacao.OrigemTramitacao.Local.SiglaLocal as sigla_orgao,
t1.IdentificacaoTramitacao.OrigemTramitacao.Local.NomeLocal as nome_orgao,
'*' as regime,
'*' as descricao_tramitacao,
t1.IdentificacaoTramitacao.Situacao.DescricaoSituacao as descricao_situacao,
t1.IdentificacaoTramitacao.Situacao.SiglaSituacao as sigla_situacao,               -- Column inserted on 2019-06-14 by hsxavier.
t1.IdentificacaoTramitacao.TextoTramitacao as despacho,
t2.ementa as ementa, 
t2.nome_autor,
t2.sigla_partido_autor,
t2.sigla_uf_autor,
t1.IdentificacaoTramitacao.DataRecebimento as data_tramitacao, -- Original name given by Joao, changing this might break gabi.
t1.IdentificacaoTramitacao.DataTramitacao AS data_tramitacao_real
FROM `gabinete-compartilhado.senado.tramitacoes` t1
JOIN 
  (SELECT 
  IdentificacaoMateria.CodigoMateria as id,
  Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.NomeParlamentar  as nome_autor,
  Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.SiglaPartidoParlamentar  as sigla_partido_autor,
  Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.UfParlamentar as sigla_uf_autor,
  IdentificacaoMateria.SiglaSubtipoMateria as sigla_tipo,
  IdentificacaoMateria.NumeroMateria  as numero,
  IdentificacaoMateria.AnoMateria  as ano,
  DadosBasicosMateria.EmentaMateria as ementa
  FROM `gabinete-compartilhado.senado.proposicoes`) t2
ON CAST(ARRAY_REVERSE(SPLIT(t1.api_url, '/'))[ORDINAL(1)] AS INT64) = t2.id