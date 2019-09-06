/***
     Tabela limpa de temas das proposições. Note que uma proposição pode aparecer mais de uma vez, com temas diferentes.
     Criamos coluna de id a partir da uri, colocamos capture_date em DATETIME.
***/

SELECT
  -- Identificação da proposição:
  CAST(ARRAY_REVERSE(SPLIT(uriProposicao, "/"))[OFFSET(0)] AS INT64) as id_proposicao,
  siglaTipo,
  numero,
  ano,
  -- Info do tema:
  codTema,
  tema,
  relevancia, 	 
  -- Link:
  uriProposicao,
  -- Info da captura:
  api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date
FROM `gabinete-compartilhado.camara_v2.proposicoes_temas`