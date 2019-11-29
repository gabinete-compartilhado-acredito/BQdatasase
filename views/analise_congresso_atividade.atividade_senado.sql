-- Tabela de atividade parlamentar no senado --

-- Primeira parte: a partir da tabela de tramitações: 
SELECT t.nome_autor, s.partido_sigla_nova AS sigla_partido_autor, t.sigla_uf_autor, t.data_tramitacao_real, t.sigla_orgao, t.despacho, t.ementa,
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(id AS STRING)) AS url,
CASE
-- Requerimento de informação:
WHEN t.sigla_tipo = 'REQ' AND LOWER(t.despacho) LIKE '%apresent%' AND LOWER(t.despacho) NOT LIKE '%aprov%'
     AND (LOWER(t.ementa) LIKE '%informações%' OR LOWER(t.ementa) LIKE '%diligência%' OR LOWER(t.ementa) LIKE '%relatório%')
     AND NOT (LOWER(t.ementa) LIKE '%convidad%' OR LOWER(t.ementa) LIKE '%convocaç%' OR LOWER(t.ementa) LIKE '%convite%' 
              OR LOWER(t.ementa) LIKE '%convocad%' OR LOWER(t.ementa) LIKE '%aditamento%' OR LOWER(t.ementa) LIKE '%audiência pública%')
THEN 'Pedidos de informação'
-- Pedido de audiência pública:
WHEN t.sigla_tipo = 'REQ' AND LOWER(t.despacho) LIKE '%apresent%'
     AND (LOWER(t.ementa) LIKE '%audiência pública%' OR LOWER(t.ementa) LIKE '%audiências públicas%' 
          OR LOWER(t.ementa) LIKE '%palestra%' OR LOWER(t.ementa) LIKE '%seminário%')
     AND LOWER(t.ementa) NOT LIKE '%aditamento%' 
     AND NOT (LOWER(t.ementa) LIKE '%convidad%' AND (LOWER(t.ementa) LIKE '%inclusão%' OR LOWER(t.ementa) LIKE '%incluir%' OR LOWER(t.ementa) LIKE '%incluíd%')) 
THEN 'Pedidos de audiência pública'
END AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_tramitacao` AS t
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
ON t.nome_autor = s.IdentificacaoParlamentar.NomeParlamentar 
WHERE t.data_tramitacao_real >= '2019-02-01'
-- Apenas seleciona tramitações classificadas em uma das categorias acima:
AND (
  -- Requerimento de informação:
  (t.sigla_tipo = 'REQ' AND LOWER(t.despacho) LIKE '%apresent%' AND LOWER(t.despacho) NOT LIKE '%aprov%'
       AND (LOWER(t.ementa) LIKE '%informações%' OR LOWER(t.ementa) LIKE '%diligência%' OR LOWER(t.ementa) LIKE '%relatório%')
       AND NOT (LOWER(t.ementa) LIKE '%convidad%' OR LOWER(t.ementa) LIKE '%convocaç%' OR LOWER(t.ementa) LIKE '%convite%' 
                OR LOWER(t.ementa) LIKE '%convocad%' OR LOWER(t.ementa) LIKE '%aditamento%' OR LOWER(t.ementa) LIKE '%audiência pública%')
  ) OR (
  -- Pedido de audiência pública:
  t.sigla_tipo = 'REQ' AND LOWER(t.despacho) LIKE '%apresent%'
       AND (LOWER(t.ementa) LIKE '%audiência pública%' OR LOWER(t.ementa) LIKE '%audiências públicas%' 
            OR LOWER(t.ementa) LIKE '%palestra%' OR LOWER(t.ementa) LIKE '%seminário%')
       AND LOWER(t.ementa) NOT LIKE '%aditamento%' 
       AND NOT (LOWER(t.ementa) LIKE '%convidad%' AND (LOWER(t.ementa) LIKE '%inclusão%' OR LOWER(t.ementa) LIKE '%incluir%' OR 
       LOWER(t.ementa) LIKE '%incluíd%')) 
  ) 
)

UNION ALL

-- Segunda parte: pedidos de desarquivamento
SELECT d.NomeParlamentar, d.partido_sigla_nova, d.uf_ultimo_mandato, d.data_tramitacao_real, d.sigla_orgao, d.despacho, d.ementa, 
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(d.id_proposicao AS STRING)) AS url,
'Pedidos de desarquivamento' AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_desarquivamentos` AS d
WHERE sigla_tipo IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV')
AND data_tramitacao_real >= '2019-02-01'


UNION ALL

-- Terceira parte: relatorias assumidas
SELECT r.nome_senador, r.partido_sigla_nova, r.uf_ultimo_mandato, r.data_designacao, r.sigla_comissao, 
CONCAT('Designado relator nesta data para ', r.sigla_tipo_materia, ' ', r.numero_materia, '/', CAST(r.ano_materia AS STRING), '.') AS despacho, 
r.ementa, 
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(codigo_materia AS STRING)) AS url,
'Relatorias assumidas' AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_senador_relatorias` AS r
WHERE r.data_designacao >= '2019-02-01'
AND r.sigla_tipo_materia IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV')
AND r.tipo_relator = 'Relator'

UNION ALL

-- Quarta parte: relatorias entregues
SELECT e.NomeParlamentar, e.partido_sigla_nova, e.uf_ultimo_mandato, e.data_tramitacao_real, e.sigla_orgao, e.despacho, e.ementa, 
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(e.id_proposicao AS STRING)) AS url,
'Relatorias entregues' AS tipo_atividade
FROM `gabinete-compartilhado.congresso.senado_relatorias_entregues` AS e
WHERE sigla_tipo IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV')
AND data_tramitacao_real >= '2019-02-01'

UNION ALL

-- Quinta parte: apresentação de proposições
SELECT 
-- Informações sobre o autor:
p.Autoria.Autor[OFFSET(0)].NomeAutor, 
s.partido_sigla_nova AS sigla_partido_autor,
p.Autoria.Autor[OFFSET(0)].IdentificacaoParlamentar.UfParlamentar,
-- Informações sobre a matéria/tramitação:
p.DadosBasicosMateria.DataApresentacao,
p.CasaIniciadoraNoLegislativo.SiglaCasaIniciadora,
CASE
WHEN p.IdentificacaoMateria.SiglaSubtipoMateria IN ('MP','MPV','PEC')
THEN CONCAT('Apresentou a ',p.IdentificacaoMateria.DescricaoIdentificacaoMateria, ', liderando a autoria.') 
ELSE CONCAT('Apresentou o ',p.IdentificacaoMateria.DescricaoIdentificacaoMateria, ', liderando a autoria.') 
END AS despacho,
p.DadosBasicosMateria.EmentaMateria,
CONCAT('https://www25.senado.leg.br/web/atividade/materias/-/materia/', CAST(IdentificacaoMateria.CodigoMateria AS STRING)) AS url,
-- Tipo de atividade:
'Propostas apresentadas' AS tipo_atividade
-- From:
FROM `gabinete-compartilhado.senado.proposicoes` AS p
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
ON p.Autoria.Autor[OFFSET(0)].NomeAutor = s.IdentificacaoParlamentar.NomeParlamentar 
WHERE LOWER(p.Autoria.Autor[OFFSET(0)].DescricaoTipoAutor) LIKE 'senador'
AND p.IdentificacaoMateria.SiglaSubtipoMateria IN ('MP','MPV','PDC','PDL','PEC','PL','PLP','PLS','PLN','PDS','PDN','PLV')
AND p.DadosBasicosMateria.DataApresentacao >= '2019-02-01'