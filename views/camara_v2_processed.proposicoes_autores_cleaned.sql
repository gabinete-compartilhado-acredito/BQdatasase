/*** 
     Tabela limpa de autores de proposições.
     Colocamos data de captura em DATETIME e criamos coluna nova com sigla nova do partido. 
***/

SELECT
  -- Info da proposição:
  a.idProposicao,
  -- Info do autor:
  a.idDeputadoAutor,
  a.codTipoAutor,
  a.tipoAutor,
  a.nomeAutor,
  a.siglaPartidoAutor AS sigla_partido_original,
  IF(a.siglaPartidoAutor = '', '', p.sigla_nova) AS sigla_partido,
  a.siglaUFAutor,
  -- Links:
  a.uriProposicao,
  a.uriAutor,
  a.uriPartidoAutor,
  -- Info da captura:
  a.api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", a.capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.proposicoes_autores` AS a
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON a.siglaPartidoAutor = p.sigla_antiga 