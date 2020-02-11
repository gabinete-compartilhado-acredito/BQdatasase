/***
     Políticos listados nas bases de renovação que atualmente (2019) estão com mandatos.
     Isso inclui todos os cargos, de verador a senador, incluindo prefeitos.
     
     - Padronizamos os nomes dos cargos vindos das duas bases (Renovação e RAPS);
     - Padronizamos os nomes dos partidos com as siglas novas.
     
     PS: só incluímos parlamentares oficialmente ligados a grupos de renovação.
 ***/

-- Lista de parlamentares em grupos de renovação (exceto RAPS):
SELECT parlamentar, grupo, cargo, p.sigla_nova AS partido_eleicao, ente, ano_ingresso
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.parlamentares_grupos_suprapartidarios`
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON partido_eleicao = p.sigla_antiga 
WHERE tipo_filiacao = 'Oficial'

UNION ALL

-- Tabela de parlamentares ainda com mandato que são da RAPS (pode existir repetição de parlamentares, 
-- cada vez com um cargo diferente, vindo das eleições 2016 e 2018):
SELECT r.nome_politico, "RAPS" AS grupo, 
CASE c.cargo
WHEN  'Deputado(a) Federal'  THEN 'Deputado federal' 
WHEN  'Deputado(a) Estadual' THEN 'Deputado estadual'
WHEN  'Deputado(a) Distrital' THEN 'Deputado distrital'
WHEN  'Governador(a)' THEN 'Governador'
WHEN  'Vice-Governador(a)' THEN 'Vice-governador'
WHEN  'Senador(a)' THEN 'Senador'
ELSE c.cargo
END,
p.sigla_nova AS partido_eleicao,
c.estado,
CAST(TRIM(SPLIT(c.periodo_eleitoral, '-')[ORDINAL(2)]) AS INT64) + 1 AS ano_ingresso
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.liderancas_raps` AS r, UNNEST(r.candidaturas) AS c 
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON c.partido = p.sigla_antiga 
WHERE (c.periodo_eleitoral = 'Eleições - 2018' OR c.periodo_eleitoral = 'Eleições - 2016')
AND c.situacao LIKE '%Eleit%'
AND c.situacao NOT LIKE '%Suplente%'

ORDER BY parlamentar
