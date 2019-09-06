SELECT 
-- Descrição da votação:
v.DataSessao, v.num_votacao, v.DescricaoVotacao, v.votacaoSecreta, 
-- Descrição da matéria:
v.tipoMateria, v.NumeroMateria, v.AnoMateria,
-- Descrição do senador:
v.id_senador, v.nome_senador, v.partido_senador, v.uf_senador, i.IdentificacaoParlamentar.UrlPaginaParlamentar AS url_senador,
-- Voto do senador e do governo:
v.DescricaoVoto, g.DescricaoVoto as voto_governo, g.orient_gov,
-- Cálculo de apoio ao governo:
CASE 
  WHEN g.orient_gov NOT IN ('Sim','Não','Obstrução') THEN NULL
  WHEN v.voto_simplificado NOT IN ('Sim','Não','Abstenção','Obstrução') THEN NULL
  WHEN v.voto_simplificado = g.orient_gov THEN 1
  WHEN v.voto_simplificado = 'Obstrução' THEN NULL
  ELSE 0
END AS apoio
--IF (g.orient_gov IS NULL, NULL, IF (v.voto_simplificado = g.orient_gov, 1, 0)) AS apoio

FROM `gabinete-compartilhado.congresso.senado_senador_votacoes` AS v 
LEFT JOIN `gabinete-compartilhado.congresso.senado_orientacao_governo` AS g
ON g.num_votacao = v.num_votacao
LEFT JOIN `gabinete-compartilhado.senado.senador_lista_atual` AS i
ON v.id_senador = i.IdentificacaoParlamentar.CodigoParlamentar 
