WITH
  -- Tabela de proposições:
  d AS (
  SELECT
    t1.id,
    PARSE_DATETIME("%Y-%m-%d", SPLIT(dataApresentacao, 'T')[ordinal(1)] ) AS data_apresentacao,
    t1.siglaTipo AS sigla_tipo,
    t1.numero,
    t1.ano,
    t1.descricaoTipo AS descricao_tipo,
    t1.ementa,
    t1.keywords,
    t1.urlInteiroTeor AS url_inteiro_teor,
    t1.ementaDetalhada AS ementa_detalhada
  FROM `gabinete-compartilhado.camara_v2.proposicoes_live` AS t1
  )
    
SELECT
  -- Informações sobre proposições:
  d1.*,
  -- Informações sobre o autor. APARENTEMENTE, PEGA O ÚLTIMO TERMO (NOME, PARTIDO, UF) DE CADA PROPOSIÇÃO, LISTADOS EM ORDEM ALFABÉTICA:
  d2.nomeAutor AS nome_autor,
  d2.siglaPartidoAutor AS sigla_partido_autor,
  d2.siglaUFAutor AS sigla_uf_autor
  
FROM d AS d1
LEFT JOIN (
  SELECT
    idProposicao,
    MAX(nomeAutor) as nomeAutor,
    MAX(siglaPartidoAutor) as siglaPartidoAutor,
    MAX(siglaUFAutor) as siglaUFAutor
  FROM `gabinete-compartilhado.camara_v2.proposicoes_autores`
  GROUP BY idProposicao 
  ) AS d2
ON
  d1.id = d2.idProposicao