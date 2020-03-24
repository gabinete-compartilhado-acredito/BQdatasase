-- Selecionando tramitações que indicam entrega de relatoria --

SELECT 
-- Identificação do relator:
s.IdentificacaoParlamentar.CodigoParlamentar, s.IdentificacaoParlamentar.NomeParlamentar, 
s.partido_sigla_nova, s.uf_ultimo_mandato,
-- Identificação da proposição:
t.id AS id_proposicao, t.sigla_tipo, t.numero, t.ano, t.ementa,
-- Identificação da tramitação:
t.data_tramitacao_real, t.descricao_situacao, t.despacho, t.sigla_orgao

FROM `gabinete-compartilhado.congresso.senado_tramitacao` AS t, `gabinete-compartilhado.senado_processed.senadores_expandida` as s

-- Localiza o relator no despacho:
WHERE LOWER(t.despacho) LIKE CONCAT('%',LOWER(s.IdentificacaoParlamentar.NomeParlamentar),'%')

-- Identifica uma entrega de relatório:
AND
(LOWER(despacho) LIKE '%relatór%' OR LOWER(despacho) LIKE '%relator%' OR LOWER(despacho) LIKE '%parecer%')
AND 
LOWER(despacho) NOT LIKE '%retificado%' AND LOWER(despacho) NOT LIKE '%reformulado%' 
AND
(LOWER(despacho) LIKE '%apresent%' OR LOWER(despacho) LIKE '%receb%' OR LOWER(despacho) LIKE '%devolv%')
AND
LOWER(descricao_situacao) NOT LIKE '%aguardando%'
AND
descricao_situacao NOT IN ('MATÉRIA COM A RELATORIA','APROVADO PARECER NA COMISSÃO','MATÉRIA DESPACHADA',
                           'PEDIDO DE VISTA CONCEDIDO', 'APROVADA', 'APROVADO O PROJETO DE LEI DE CONVERSÃO')