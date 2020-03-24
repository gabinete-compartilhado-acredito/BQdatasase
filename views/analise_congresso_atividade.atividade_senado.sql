-- Tabela de atividade parlamentar no senado --

-- Primeira parte: pedidos de desarquivamento
SELECT d.NomeParlamentar AS nome_autor, d.partido_sigla_nova AS sigla_partido_autor, 
d.uf_ultimo_mandato AS sigla_uf_autor, d.data_tramitacao_real, d.sigla_orgao, d.despacho, d.ementa, 
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(d.id_proposicao AS STRING)) AS url,
'Pedidos de desarquivamento' AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_desarquivamentos` AS d
WHERE sigla_tipo IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV','PLC')
AND data_tramitacao_real >= '2019-02-01'


UNION ALL

-- Segunda parte: relatorias assumidas
SELECT r.nome_senador, r.partido_sigla_nova, r.uf_ultimo_mandato, r.data_designacao, r.sigla_comissao, 
CONCAT('Designado relator nesta data para ', r.sigla_tipo_materia, ' ', r.numero_materia, '/', CAST(r.ano_materia AS STRING), '.') AS despacho, 
r.ementa, 
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(codigo_materia AS STRING)) AS url,
'Relatorias assumidas' AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_senador_relatorias` AS r
WHERE r.data_designacao >= '2019-02-01'
--AND r.sigla_tipo_materia IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV','PLC')
AND r.tipo_relator = 'Relator'
AND (data_destituicao IS NULL OR motivo_destituicao IN ('Deliberação da matéria', 'Matéria com tramitação encerrada'))

UNION ALL

-- Terceira parte: relatorias entregues
SELECT e.NomeParlamentar, e.partido_sigla_nova, e.uf_ultimo_mandato, e.data_tramitacao_real, e.sigla_orgao, e.despacho, e.ementa, 
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(e.id_proposicao AS STRING)) AS url,
'Relatorias entregues' AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_relatorias_entregues` AS e
WHERE data_tramitacao_real >= '2019-02-01'
--AND sigla_tipo IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV','PLC')

UNION ALL

-- Quarta parte: seleção de atividades a partir da tabela de proposições (pedidos de informação, audiência pública e propostas apresentadas)
SELECT sen.IdentificacaoParlamentar.NomeParlamentar, sen.partido_sigla_nova, sen.uf_ultimo_mandato, 
prop.Data_Apresentacao, prop.Sigla_Comissao_Requerimento, 
CONCAT(sen.IdentificacaoParlamentar.NomeParlamentar, ' (', sen.partido_sigla_nova, '-', sen.uf_ultimo_mandato, ') apresentou o(a) ', 
prop.Descricao_Identificacao_Materia, ' nesta data.'), prop.Ementa_Materia,
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(prop.Codigo_Materia AS STRING)) AS url,

CASE
  -- Pedido de informação:
  WHEN 
  (UPPER(Descricao_Subtipo_Materia) LIKE '%REQUERIMENTO%' OR UPPER(Descricao_Subtipo_Materia) LIKE '%REQ.%') 
    AND (
      LOWER(Ementa_Materia) LIKE '%informações%' 
      OR LOWER(Ementa_Materia) LIKE '%diligência%' 
      OR LOWER(Ementa_Materia) LIKE '%relatório%'
      )
    AND NOT (
      LOWER(Ementa_Materia) LIKE '%convidad%' 
      OR LOWER(Ementa_Materia) LIKE '%convocaç%' 
      OR LOWER(Ementa_Materia) LIKE '%convite%' 
      OR LOWER(Ementa_Materia) LIKE '%convocad%' 
      OR LOWER(Ementa_Materia) LIKE '%aditamento%' 
      OR LOWER(Ementa_Materia) LIKE '%audiência pública%'
      )
  THEN 'Pedidos de informação'
  -- Pedido de audiência pública:
  WHEN
    (  
  (UPPER(Descricao_Subtipo_Materia) LIKE '%REQUERIMENTO%' OR UPPER(Descricao_Subtipo_Materia) LIKE '%REQ.%')
  AND (LOWER(Ementa_Materia) LIKE '%audiência pública%' 
    OR LOWER(Ementa_Materia) LIKE '%audiências públicas%' 
    OR LOWER(Ementa_Materia) LIKE '%palestra%' 
    OR LOWER(Ementa_Materia) LIKE '%seminário%')
  AND LOWER(Ementa_Materia) NOT LIKE '%aditamento%' 
  AND NOT (LOWER(Ementa_Materia) LIKE '%convidad%' AND (LOWER(Ementa_Materia) LIKE '%inclusão%' OR LOWER(Ementa_Materia) LIKE '%incluir%' OR 
           LOWER(Ementa_Materia) LIKE '%incluíd%'))
  )
  THEN 'Pedidos de audiência pública'
  -- Apresentação de proposição:
  WHEN Sigla_Subtipo_Materia IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV','PLC')
  THEN 'Propostas apresentadas' 
  END AS tipo_atividade
  
FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS prop
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS sen
-- Seleciona como autor apenas o primeiro, que em geral é o responsável pelo documento e não um signatário de apoio:
ON prop.Autoria[OFFSET(0)].IdentificacaoParlamentar.CodigoParlamentar = sen.IdentificacaoParlamentar.CodigoParlamentar 

-- Recortes:
WHERE Ano_Materia >= 2019 AND LOWER(Autoria[OFFSET(0)].DescricaoTipoAutor) LIKE '%senador%'
  AND (
  -- Requerimento de informação:
  (
  (UPPER(Descricao_Subtipo_Materia) LIKE '%REQUERIMENTO%' OR UPPER(Descricao_Subtipo_Materia) LIKE '%REQ.%') 
  AND (
    LOWER(Ementa_Materia) LIKE '%informações%' 
    OR LOWER(Ementa_Materia) LIKE '%diligência%' 
    OR LOWER(Ementa_Materia) LIKE '%relatório%'
    )
  AND NOT (
    LOWER(Ementa_Materia) LIKE '%convidad%' 
    OR LOWER(Ementa_Materia) LIKE '%convocaç%' 
    OR LOWER(Ementa_Materia) LIKE '%convite%' 
    OR LOWER(Ementa_Materia) LIKE '%convocad%' 
    OR LOWER(Ementa_Materia) LIKE '%aditamento%' 
    OR LOWER(Ementa_Materia) LIKE '%audiência pública%'
    )
  ) OR 
  -- Pedido de audiência pública: 
  (  
  (UPPER(Descricao_Subtipo_Materia) LIKE '%REQUERIMENTO%' OR UPPER(Descricao_Subtipo_Materia) LIKE '%REQ.%')
  AND (LOWER(Ementa_Materia) LIKE '%audiência pública%' 
    OR LOWER(Ementa_Materia) LIKE '%audiências públicas%' 
    OR LOWER(Ementa_Materia) LIKE '%palestra%' 
    OR LOWER(Ementa_Materia) LIKE '%seminário%')
  AND LOWER(Ementa_Materia) NOT LIKE '%aditamento%' 
  AND NOT (LOWER(Ementa_Materia) LIKE '%convidad%' AND (LOWER(Ementa_Materia) LIKE '%inclusão%' OR LOWER(Ementa_Materia) LIKE '%incluir%' OR 
           LOWER(Ementa_Materia) LIKE '%incluíd%'))
  ) OR
  -- Proposições:
  Sigla_Subtipo_Materia IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV','PLC')
  )