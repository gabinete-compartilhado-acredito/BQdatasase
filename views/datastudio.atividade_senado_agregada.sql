SELECT nome_autor, sigla_partido_autor, sigla_uf_autor,
--COUNTIF(tipo_atividade = 'Aprovações de requerimentos') AS aprov_req,
--COUNTIF(tipo_atividade = 'Discussões de matéria') AS discussao_materia,
--COUNTIF(tipo_atividade = 'Obstruções da discussão (Plenário)') AS obstrucao,
--COUNTIF(tipo_atividade = 'Outros') AS outros,
COUNTIF(tipo_atividade = 'Pedidos de audiência pública') AS aud_publica,
COUNTIF(tipo_atividade = 'Pedidos de desarquivamento') AS desarquivamento,
COUNTIF(tipo_atividade = 'Pedidos de informação') AS informacao,
COUNTIF(tipo_atividade = 'Relatorias assumidas') AS relat_assumidas,
COUNTIF(tipo_atividade = 'Relatorias entregues') AS relat_entregues,
COUNTIF(tipo_atividade = 'Apres. PL/PEC/PDL/PLP') AS apresenta_pro
FROM `gabinete-compartilhado.datastudio.atividade_senado_`
GROUP BY nome_autor, sigla_partido_autor, sigla_uf_autor
ORDER by nome_autor 