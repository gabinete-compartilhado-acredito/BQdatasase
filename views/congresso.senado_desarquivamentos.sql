-- Selecionando tramitações que indicam desarquivamento de proposições --

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

-- Identifica um pedido de desarquivamento:
AND 
LOWER(t.despacho) LIKE '%desarquiv%' AND LOWER(t.despacho) LIKE '%publicação%' AND LOWER(t.despacho) NOT LIKE '%aprov%'