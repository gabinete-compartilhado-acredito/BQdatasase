SELECT 
sigla_nova,
nome, 
CAST(ARRAY_REVERSE(SPLIT(uri, '/'))[ORDINAL(1)] AS INT64) as id,
status.totalMembros AS total_membros
FROM `gabinete-compartilhado.camara_v2.partidos_detalhes`  t1
JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` t2 
ON t1.sigla = t2.sigla_antiga 