SELECT t2.nome as relator, t1.*
FROM `gabinete-compartilhado.camara_v2.proposicoes` t1
JOIN `gabinete-compartilhado.camara_v2.deputados` t2
ON t1.ultimoStatus.uriRelator = t2.uri