/***
    Dados de votações dos senadores, com voto simplificado.
    Nem todas as colunas da parent view foram replicadas aqui.
    Foram incluídas informações sobre o senador em questão
    (nome, partido e uf).
 ***/
 
-- Dados da votação:
SELECT 
  v.id_votacao, v.data_sessao, v.descricao_votacao, v.resultado_votacao, v.votacao_secreta, 
  -- Dados da matéria:
  v.id_proposicao, v.sigla_tipo_proposicao, v.num_proposicao, v.ano_proposicao,
  -- Dados do senador:
  v.id_senador, 
  s.IdentificacaoParlamentar.NomeParlamentar as nome_senador, s.IdentificacaoParlamentar.SiglaPartidoParlamentar AS sigla_partido_original, p.sigla_nova as partido_senador, 
  s.IdentificacaoParlamentar.UfParlamentar as uf_senador, 

-- Votos:
v.descricao_voto,
v.sigla_voto, 
CASE v.sigla_voto
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
END AS voto_simplificado

FROM `gabinete-compartilhado.senado_processed.senador_votacoes_cleaned` AS v 
LEFT JOIN `gabinete-compartilhado.senado.senadores` AS s
ON v.id_senador = s.IdentificacaoParlamentar.CodigoParlamentar 
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p 
ON p.sigla_antiga = s.IdentificacaoParlamentar.SiglaPartidoParlamentar