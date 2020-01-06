WITH alinha_table AS (
  SELECT a.id_senador_2, COUNT(a.alinhamento) AS n_votos, AVG(a.alinhamento) AS alinhamento
  FROM `gabinete-compartilhado.analise_congresso_votacoes.senado_senador_senador` AS a
  WHERE id_senador_1 = 5982 -- Alessandro Vieira --
  GROUP BY a.id_senador_2
)

SELECT
  -- Info do senador:
  alinha_table.id_senador_2,
  s.IdentificacaoParlamentar.NomeParlamentar As nome_senador_2,
  s.partido_sigla_nova As partido_senador_2,
  s.IdentificacaoParlamentar.UfParlamentar AS uf_senador_2,
  -- Info do alinhamento:
  alinha_table.n_votos,
  alinha_table.alinhamento 

FROM alinha_table 
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
ON alinha_table.id_senador_2 = s.IdentificacaoParlamentar.CodigoParlamentar 
ORDER BY alinhamento DESC