/* Cria uma tabela de ID para as votações a partir de 6 colunas ordenadas */
WITH id_votacao AS (
  SELECT SessaoPlenaria.DataSessao AS data, 
    IdentificacaoMateria.NumeroMateria AS numMateria, 
    DescricaoVotacao AS descricaoVotacao, 
    DescricaoResultado AS resultado,
    CodigoSessaoVotacao AS cod_sessao_votacao,
    Sequencial AS sequencial,
    row_number() OVER (ORDER BY SessaoPlenaria.DataSessao, IdentificacaoMateria.NumeroMateria, DescricaoVotacao, DescricaoResultado, CodigoSessaoVotacao, Sequencial) 
      AS num_votacao
  FROM `gabinete-compartilhado.senado.senador_votacoes` 
  GROUP BY IdentificacaoMateria.NumeroMateria, DescricaoVotacao, SessaoPlenaria.DataSessao, DescricaoResultado, CodigoSessaoVotacao, Sequencial
)

/* Cria tabela com número da votação acima e id do senador */
-- Dados da votação:
SELECT id_votacao.num_votacao,
  v.SessaoPlenaria.DataSessao, v.DescricaoVotacao, v.DescricaoResultado, v.IndicadorVotacaoSecreta as votacaoSecreta,
  -- Dados da matéria:
  v.IdentificacaoMateria.SiglaSubtipoMateria as tipoMateria, v.IdentificacaoMateria.NumeroMateria, v.IdentificacaoMateria.AnoMateria,
  CAST(ARRAY_REVERSE(SPLIT(v.api_url, '/'))[ORDINAL(2)] AS INT64) AS id_senador, 
  -- Dados do senador:
  s.IdentificacaoParlamentar.NomeParlamentar as nome_senador, p.sigla_nova as partido_senador, 
  s.IdentificacaoParlamentar.UfParlamentar as uf_senador, 

-- Votos:
v.SiglaDescricaoVoto,
CASE v.SiglaDescricaoVoto 
  WHEN 'Sim' THEN 'Sim'
  WHEN 'Não' THEN 'Não'
  WHEN 'Obstrução' THEN 'Obstrução'
  WHEN 'P-OD' THEN 'Obstrução'
  WHEN 'Não - Presidente Art.48 inciso XXIII' THEN 'Não'
  WHEN 'Sim - Presidente Art.48 inciso XXIII' THEN 'Sim'
  WHEN 'Votou' THEN 'Votou'
  WHEN 'Abstenção' THEN 'Abstenção'
  WHEN 'P-NRV' THEN 'Abstenção'
  WHEN NULL THEN NULL
  ELSE 'Outros'
END AS voto_simplificado,
-- Voto BOOL (ERRADO, obstrução não é equivalente a Não!):
  CASE
    WHEN v.SiglaDescricaoVoto = 'Obstrução' THEN 0
    WHEN v.SiglaDescricaoVoto = 'Não' THEN 0
    WHEN v.SiglaDescricaoVoto = 'Sim' THEN 1
  END AS voto_bool

FROM id_votacao, `gabinete-compartilhado.senado.senador_votacoes` AS v 
LEFT JOIN `gabinete-compartilhado.senado.senadores` AS s
ON s.IdentificacaoParlamentar.CodigoParlamentar = CAST(ARRAY_REVERSE(SPLIT(v.api_url, '/'))[ORDINAL(2)] AS INT64)
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p 
ON p.sigla_antiga = s.IdentificacaoParlamentar.SiglaPartidoParlamentar 
WHERE id_votacao.data = v.SessaoPlenaria.DataSessao
AND id_votacao.numMateria = v.IdentificacaoMateria.NumeroMateria 
AND id_votacao.descricaoVotacao = v.DescricaoVotacao 
AND id_votacao.resultado = v.DescricaoResultado
AND id_votacao.cod_sessao_votacao = v.CodigoSessaoVotacao
AND id_votacao.sequencial = v.Sequencial

ORDER BY num_votacao