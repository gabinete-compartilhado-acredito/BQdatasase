SELECT l.id_denador as id_lider_gov, l.nome_senador as nome_lider_gov, l.partido as partido_lider_gov, l.uf as uf_lider_gov, 
v.num_votacao, l.ano, l.legislatura, v.DataSessao, v.DescricaoVoto, v.voto_simplificado, v.voto_bool,

CASE v.voto_simplificado 
  WHEN 'Sim' THEN 'Sim'
  WHEN 'Não' THEN 'Não'
  WHEN 'Obstrução' THEN 'Obstrução'
  WHEN 'Abstenção' THEN 'Liberado'
  WHEN 'P-NRV' THEN 'Liberado'
  ELSE 'Desconhecido'
END AS orient_gov

FROM `gabinete-compartilhado.congresso.senado_senador_votacoes` as v, `gabinete-compartilhado.senado.lider_governo_senado` as l
WHERE 
l.id_denador = v.id_senador 
AND v.DataSessao BETWEEN l.data_inicio AND l.data_fim
ORDER BY v.DataSessao
