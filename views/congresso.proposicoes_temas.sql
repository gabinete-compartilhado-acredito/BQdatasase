SELECT t1.*, t2.macro_tema,  CAST(ARRAY_REVERSE(SPLIT(t1.uriProposicao, '/'))[ORDINAL(1)] AS INT64) as id
FROM  `gabinete-compartilhado.camara_v2.proposicoes_temas` t1
JOIN `gabinete-compartilhado.congresso.macro_temas` t2
ON t1.tema = t2.tema
LIMIT 1000