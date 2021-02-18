-- Same as senado.senadores, but with extra columns --

-- Create table of senator's id and last legislature the senator was elected:
-- Ou seja: a legislatura é a primeira do último mandato (sendo que cada mandato tem duas legislaturas).
-- Para selecionar senadores ativos, na legislatura 56, pegar os com legislatura IN (55, 56).
WITH t_ultimo_mandato AS (
  SELECT s.IdentificacaoParlamentar.CodigoParlamentar AS id_senador, MAX(m.PrimeiraLegislaturaDoMandato.NumeroLegislatura) AS legislatura
  FROM `gabinete-compartilhado.senado.senadores` AS s, UNNEST(s.Mandatos.Mandato) AS m
  GROUP BY s.IdentificacaoParlamentar.CodigoParlamentar
)

-- Select original columns:
SELECT s.*, 
-- Primeira legislatura do último mandato:
legislatura,
-- Add a column with the last mandate's UF:
m.UfParlamentar AS uf_ultimo_mandato,
m.DescricaoParticipacao AS titularidade_ultimo_mandato,
ARRAY_LENGTH(m.Exercicios.Exercicio) AS n_exercicios,
-- Add party's new name:
p.sigla_nova as partido_sigla_nova

-- Select from senado.senadores by joining with other tables ans slicing to relevant data:
FROM `gabinete-compartilhado.senado.senadores` AS s
-- Join parties' new names:
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON s.IdentificacaoParlamentar.SiglaPartidoParlamentar = p.sigla_antiga, 
-- Join last mandate:
UNNEST(s.Mandatos.Mandato) AS m, t_ultimo_mandato
WHERE t_ultimo_mandato.id_senador = s.IdentificacaoParlamentar.CodigoParlamentar
AND t_ultimo_mandato.legislatura = m.PrimeiraLegislaturaDoMandato.NumeroLegislatura

