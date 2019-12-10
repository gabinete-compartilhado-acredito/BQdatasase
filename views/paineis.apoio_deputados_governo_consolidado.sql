SELECT 
  -- Id do deputado:
  id_deputado,
  -- Alinhamento ao partido:
  AVG(apoio_partido) AS alinhamento_partido, COUNT(apoio_partido) AS n_votacoes_partido, 
  -- Alinhamento ao governo:
  AVG(apoio) AS alinhamento_gov, COUNT(apoio) AS n_votacoes_gov 
  
FROM `gabinete-compartilhado.paineis.apoio_deputados_governo`
GROUP BY id_deputado