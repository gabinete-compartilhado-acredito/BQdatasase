/***
 Essa tabela apresenta, para cada evento (e.g. reunião), vetores que agregam todos os itens da pauta.
 ***/

-- Agrega numa strings todas as situações de uma proposição presente na pauta de uma reunião:
WITH agg_situacao_item AS (
  SELECT 
    id_evento, proposicao_id, 
    STRING_AGG(situacao_item, ' | ') AS situacao_item
  FROM `gabinete-compartilhado.camara_v2_processed.eventos_pauta_cleaned`
  GROUP BY id_evento, proposicao_id, ordem_pauta, cod_regime, regime
)

-- Agrega em vetores todos os itens da pauta de cada reunião:
SELECT 
  p.id_evento, 
  ARRAY_AGG(IF(p.ordem_pauta IS NULL,-1, p.ordem_pauta) ORDER BY p.ordem_pauta) AS ordem_pauta,
  ARRAY_AGG(IF(p.proposicao_id IS NULL, -1, p.proposicao_id) ORDER BY p.ordem_pauta) AS proposicao_id,
  ARRAY_AGG(IF(p.proposicao_cod_tipo IS NULL, -1, p.proposicao_cod_tipo) ORDER BY p.ordem_pauta) AS proposicao_cod_tipo,
  ARRAY_AGG(IF(p.proposicao_sigla_tipo IS NULL, '', p.proposicao_sigla_tipo) ORDER BY p.ordem_pauta) AS proposicao_sigla_tipo,
  ARRAY_AGG(IF(p.proposicao_numero IS NULL, -1, p.proposicao_numero) ORDER BY p.ordem_pauta) AS proposicao_numero,
  ARRAY_AGG(IF(p.proposicao_ano IS NULL, -1, p.proposicao_ano) ORDER BY p.ordem_pauta) AS proposicao_ano,
  ARRAY_AGG(IF(p.proposicao_ementa IS NULL, '', p.proposicao_ementa) ORDER BY p.ordem_pauta) AS proposicao_ementa,
  ARRAY_AGG(IF(p.proposicao_uri IS NULL, '', p.proposicao_uri) ORDER BY p.ordem_pauta) AS proposicao_uri,
  ARRAY_AGG(IF(p.uri_proposicao_relacionada IS NULL, '', p.uri_proposicao_relacionada) ORDER BY p.ordem_pauta) AS uri_proposicao_relacionada,
  ARRAY_AGG(IF(p.cod_regime IS NULL, -1, p.cod_regime) ORDER BY p.ordem_pauta) AS cod_regime,
  ARRAY_AGG(IF(p.regime IS NULL, '', p.regime) ORDER BY p.ordem_pauta) AS regime,
  ARRAY_AGG(IF(a.situacao_item IS NULL, '', a.situacao_item) ORDER BY p.ordem_pauta) AS situacao_item,
  STRING_AGG(CONCAT(CAST(p.ordem_pauta AS STRING), '. ', p.proposicao_sigla_tipo, CASt(p.proposicao_numero AS STRING), '/', CAST(p.proposicao_ano AS STRING), ': ',
    p.proposicao_ementa), '\n' ORDER BY p.ordem_pauta) AS pauta,
  p.capture_date, p.api_url

FROM (
  -- Seleciona apenas uma entrada para cada proposição:
  SELECT DISTINCT id_evento, ordem_pauta, proposicao_id, proposicao_cod_tipo, proposicao_sigla_tipo, proposicao_numero, proposicao_ano, proposicao_ementa,
    proposicao_uri, uri_proposicao_relacionada, cod_regime, regime, capture_date, api_url
  FROM `gabinete-compartilhado.camara_v2_processed.eventos_pauta_cleaned`
) AS p
-- Junta com as descrições da situação de cada proposição
LEFT JOIN agg_situacao_item AS a 
ON p.id_evento = a.id_evento AND p.proposicao_id = a.proposicao_id
GROUP BY id_evento, api_url, capture_date
ORDER BY id_evento
