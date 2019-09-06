SELECT
  w1.*,
  w2.sigla_nova
FROM (
  SELECT
    t1.*,
    t2.IdentificacaoParlamentar.NomeParlamentar AS nome_senador,
    t2.IdentificacaoParlamentar.SiglaPartidoParlamentar AS sigla_antiga
  FROM (
    SELECT
      CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[ORDINAL(2)] AS INT64) AS id_parlamentar,
      PARSE_DATE('%Y-%m-%d',
        DataDesignacao) AS data_designacao,
      PARSE_DATE('%Y-%m-%d',
        DataDestituicao) AS data_destituicao,
      Comissao.IdentificacaoComissao.NomeComissao AS comissao,
      Materia.IdentificacaoMateria.CodigoMateria AS codigo_materia,
      Materia.IdentificacaoMateria.AnoMateria AS ano_materia,
      Materia.IdentificacaoMateria.SiglaSubtipoMateria AS sigla_tipo_materia,
      Materia.IdentificacaoMateria.NumeroMateria AS numero_materia,
      DescricaoTipoRelator as tipo_relator
    FROM
      `gabinete-compartilhado.senado.senador_relatorias`) t1
  LEFT JOIN
    `gabinete-compartilhado.senado.senadores` AS t2
  ON
    t2.IdentificacaoParlamentar.CodigoParlamentar = id_parlamentar) w1
LEFT JOIN
  `gabinete-compartilhado.congresso.partidos_novas_siglas` w2
ON
  w1.sigla_antiga = w2.sigla_antiga