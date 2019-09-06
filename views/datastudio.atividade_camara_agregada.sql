SELECT nome_parlamentar, sigla_partido, sigla_uf,
COUNTIF(tipo_atividade = 'Aprovações de requerimentos') AS aprov_req,
COUNTIF(tipo_atividade = 'Discussões de matéria') AS discussao_materia,
COUNTIF(tipo_atividade = 'Obstruções da discussão (Plenário)') AS obstrucao,
COUNTIF(tipo_atividade = 'Outros') AS outros,
COUNTIF(tipo_atividade = 'Pedidos de audiência pública') AS aud_publica,
COUNTIF(tipo_atividade = 'Pedidos de desarquivamento') AS desarquivamento,
COUNTIF(tipo_atividade = 'Pedidos de informação') AS informacao,
COUNTIF(tipo_atividade = 'Relatorias assumidas') AS relat_assumidas,
COUNTIF(tipo_atividade = 'Relatorias entregues') AS relat_entregues,
COUNTIF(tipo_atividade = 'Apres. de propostas/projetos') AS apresenta_pro
FROM `gabinete-compartilhado.datastudio.atividade_camara`
GROUP BY nome_parlamentar, sigla_partido, sigla_uf
ORDER by nome_parlamentar