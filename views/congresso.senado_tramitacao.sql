SELECT
'senado' AS casa,
t2.IdentificacaoMateria.CodigoMateria AS id,
t2.IdentificacaoMateria.SiglaSubtipoMateria AS sigla_tipo,
t2.IdentificacaoMateria.NumeroMateria  AS numero,
t2.IdentificacaoMateria.AnoMateria AS ano,

datetime(timestamp(t1.capture_date), 'America/Sao_Paulo') AS data_hora,

ROW_NUMBER() OVER(partition by t2.IdentificacaoMateria.CodigoMateria) AS sequencia,

t1.IdentificacaoTramitacao.OrigemTramitacao.Local.SiglaLocal AS sigla_orgao,
t1.IdentificacaoTramitacao.OrigemTramitacao.Local.NomeLocal AS nome_orgao,
'*' AS regime,
'*' AS descricao_tramitacao,
t1.IdentificacaoTramitacao.Situacao.DescricaoSituacao AS descricao_situacao,
t1.IdentificacaoTramitacao.Situacao.SiglaSituacao AS sigla_situacao,               -- Column inserted on 2019-06-14 by hsxavier.
t1.IdentificacaoTramitacao.TextoTramitacao AS despacho,

t2.DadosBasicosMateria.EmentaMateria AS ementa, 
t2.Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.NomeParlamentar AS nome_autor,
t2.Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.SiglaPartidoParlamentar AS sigla_partido_antiga, -- Old sigla_partido_autor
p.sigla_nova AS sigla_partido_autor, -- New column (nova sigla do partido)
t2.Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.UfParlamentar AS sigla_uf_autor,

t1.IdentificacaoTramitacao.DataRecebimento AS data_tramitacao, -- Original name given by Joao, changing this might break gabi.
t1.IdentificacaoTramitacao.DataTramitacao AS data_tramitacao_real -- Column inserted aroung 2019-jul by hsxavier

FROM `gabinete-compartilhado.senado.tramitacoes` AS t1
JOIN `gabinete-compartilhado.senado.proposicoes` AS t2
ON CAST(ARRAY_REVERSE(SPLIT(t1.api_url, '/'))[ORDINAL(1)] AS INT64) = t2.IdentificacaoMateria.CodigoMateria
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` as p
ON t2.Autoria.Autor[ORDINAL(1)].IdentificacaoParlamentar.SiglaPartidoParlamentar = p.sigla_antiga 