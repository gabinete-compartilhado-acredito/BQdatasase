WITH
  d AS (
  SELECT
    t1.id,
    PARSE_DATETIME("%Y-%m-%d",
      SPLIT(dataApresentacao, 'T')[ORDINAL(1)] ) AS data_apresentacao,
    t1.siglaTipo AS sigla_tipo,
    t1.numero,
    t1.ano,
    t1.descricaoTipo AS descricao_tipo,
    t1.ementa,
    t1.keywords,
    t1.urlInteiroTeor AS url_inteiro_teor,
    t1.ementaDetalhada AS ementa_detalhada
  FROM
    `gabinete-compartilhado.camara_v2.proposicoes` t1)
SELECT
  d1.*,
  d2.id_deputado,
  d2.nomeAutor AS nome_autor,
  d2.siglaPartidoAutor AS sigla_partido_autor,
  d2.siglaUFAutor AS sigla_uf_autor
FROM
  d d1
LEFT JOIN (
  SELECT
    idProposicao,
    idDeputadoAutor AS id_deputado,
    nomeAutor AS nomeAutor,
    k2.sigla_nova AS siglaPartidoAutor,
    siglaUFAutor AS siglaUFAutor
  FROM (
    SELECT
      *
    FROM (
      SELECT
        idProposicao,
        idDeputadoAutor,
        nomeAutor,
        siglaPartidoAutor,
        siglaUFAutor,
        ROW_NUMBER() OVER(PARTITION BY idProposicao) AS row_number
      FROM
        `gabinete-compartilhado.camara_v2.proposicoes_autores`) 
    WHERE
      row_number = 1) k1
  LEFT OUTER JOIN
    `gabinete-compartilhado.congresso.partidos_novas_siglas` k2
  ON
    k1.siglaPartidoAutor = k2.sigla_antiga ) d2
ON
  d1.id = d2.idProposicao