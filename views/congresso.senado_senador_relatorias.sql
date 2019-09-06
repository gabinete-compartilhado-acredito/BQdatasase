SELECT
  -- Informações sobre o parlamentar:
  CAST(ARRAY_REVERSE(SPLIT(r.api_url, '/'))[ORDINAL(2)] AS INT64) AS id_parlamentar,
  s.IdentificacaoParlamentar.NomeParlamentar AS nome_senador,
  s.IdentificacaoParlamentar.SiglaPartidoParlamentar AS partido_sigla_antiga,
  s.partido_sigla_nova,
  s.uf_ultimo_mandato,
  -- Informações sobre 
  PARSE_DATE('%Y-%m-%d', r.DataDesignacao) AS data_designacao,
  PARSE_DATE('%Y-%m-%d', r.DataDestituicao) AS data_destituicao,
  r.Comissao.IdentificacaoComissao.SiglaComissao AS sigla_comissao,
  r.Comissao.IdentificacaoComissao.NomeComissao AS comissao,
  r.Materia.IdentificacaoMateria.CodigoMateria AS codigo_materia,
  r.Materia.IdentificacaoMateria.AnoMateria AS ano_materia,
  r.Materia.IdentificacaoMateria.SiglaSubtipoMateria AS sigla_tipo_materia,
  r.Materia.IdentificacaoMateria.NumeroMateria AS numero_materia,
  r.Materia.EmentaMateria AS ementa,
  r.DescricaoTipoRelator AS tipo_relator
FROM `gabinete-compartilhado.senado.senador_relatorias` AS r
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
ON s.IdentificacaoParlamentar.CodigoParlamentar = CAST(ARRAY_REVERSE(SPLIT(r.api_url, '/'))[ORDINAL(2)] AS INT64)
