-- Dentre as entradas duplicadas de projetos de lei, selecionamos aquelas com a capture_date mais recente.
-- Em geral, duplicidades significam atualizações na numeração dos PLs.

SELECT p.id, 
  ARRAY_AGG(p.codTipo ORDER BY p.capture_date DESC)[OFFSET(0)] AS codTipo, 
  ARRAY_AGG(p.descricaoTipo ORDER BY p.capture_date DESC)[OFFSET(0)] AS descricaoTipo, 
  ARRAY_AGG(p.siglaTipo ORDER BY p.capture_date DESC)[OFFSET(0)] AS siglaTipo, 
  ARRAY_AGG(p.numero ORDER BY p.capture_date DESC)[OFFSET(0)] AS numero, 
  ARRAY_AGG(p.ano ORDER BY p.capture_date DESC)[OFFSET(0)] AS ano, 
  ARRAY_AGG(p.data_apresentacao ORDER BY p.capture_date DESC)[OFFSET(0)] AS data_apresentacao, 
  ARRAY_AGG(p.ementa ORDER BY p.capture_date DESC)[OFFSET(0)] AS ementa, 
  ARRAY_AGG(p.ementaDetalhada ORDER BY p.capture_date DESC)[OFFSET(0)] AS ementaDetalhada , 
  ARRAY_AGG(p.keywords ORDER BY p.capture_date DESC)[OFFSET(0)] AS keywords, 
  ARRAY_AGG(p.uri ORDER BY p.capture_date DESC)[OFFSET(0)] AS uri, 
  ARRAY_AGG(p.uriPropPosterior ORDER BY p.capture_date DESC)[OFFSET(0)] AS uriPropPosterior,
  ARRAY_AGG(p.uriPropPrincipal ORDER BY p.capture_date DESC)[OFFSET(0)] AS uriPropPrincipal,
  ARRAY_AGG(p.urlInteiroTeor ORDER BY p.capture_date DESC)[OFFSET(0)] AS urlInteiroTeor, 
  ARRAY_AGG(p.api_url ORDER BY p.capture_date DESC)[OFFSET(0)] AS api_url, 
  ARRAY_AGG(p.capture_date ORDER BY p.capture_date DESC)[OFFSET(0)] AS capture_date,
  COUNT(*) AS n_copias
  
FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS p
GROUP BY id