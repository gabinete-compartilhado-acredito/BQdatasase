-- Add column to analise_congresso_atividade.tramitacao_por_parlamentar_ with the kind of activity --

SELECT nome_parlamentar, sigla_partido, sigla_uf, data_hora, sigla_orgao, despacho, ementa, url,
--SELECT id, sigla_tipo, numero, ano, data_hora, sequencia, sigla_orgao, descricao_situacao, descricao_tramitacao, nome_parlamentar,

-- TIPO DE ATIVIDADE --
CASE
WHEN descricao_tramitacao = 'Designação de Relator' AND sigla_tipo IN ('PL', 'PEC', 'MPV', 'PLC', 'PDL', 'PDC', 'PDN', 'PDS', 'PLP')
THEN 'Relatorias assumidas'
WHEN descricao_tramitacao = 'Parecer do Relator' AND sigla_tipo IN ('PL', 'PEC', 'MPV', 'PLC', 'PDL', 'PDC', 'PDN', 'PDS', 'PLP')
THEN 'Relatorias entregues'
WHEN descricao_tramitacao = 'Apresentação de Proposição' AND sigla_tipo = 'RIC'
THEN 'Pedidos de informação'
WHEN descricao_tramitacao = 'Obstrução Discussão (Plenário)'
THEN 'Obstruções da discussão (Plenário)'
WHEN descricao_tramitacao = 'Discussão da Materia pelos Deputados' OR LOWER(despacho) LIKE '%discutiu a matéria%'
THEN 'Discussões de matéria'
WHEN descricao_tramitacao = 'Aprovação de Requerimento'
THEN 'Aprovações de requerimentos'
WHEN descricao_tramitacao = 'Apresentação de Proposição' AND sigla_tipo = 'REQ' AND lower(despacho) LIKE '%audiência pública%'
AND lower(ementa) NOT LIKE '%aditamento%'
AND NOT (lower(ementa) LIKE '%convidad%' AND (lower(ementa) LIKE '%inclusão%' OR lower(ementa) LIKE '%incluir%' OR lower(ementa) LIKE '%incluíd%'))
THEN 'Pedidos de audiência pública'
WHEN descricao_tramitacao IN ('Apresentação de Proposição', 'Apresentação de Requerimento') AND lower(despacho) LIKE '%desarquivamento%'
THEN 'Pedidos de desarquivamento'
WHEN descricao_tramitacao = 'Apresentação de Proposição'
     AND sigla_tipo IN ('PL', 'PEC', 'PLC', 'PDL', 'PDC', 'PDN', 'PDS', 'PLP')
     AND (LOWER(despacho) LIKE '%apresentação __ projeto __ lei%' OR 
          LOWER(despacho) LIKE '%apresentação __ projeto __ decreto legislativo%' OR 
          LOWER(despacho) LIKE '%apresentação __ proposta __ emenda%')
THEN 'Apres. de propostas/projetos'
ELSE 'Outros'
END AS tipo_atividade

FROM `gabinete-compartilhado.analise_congresso_atividade.tramitacao_por_parlamentar_`