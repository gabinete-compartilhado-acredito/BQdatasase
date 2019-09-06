WITH

-- Tabela de tramitações agrupadas por captura e data de tramitação --
grouped AS (
  SELECT id_proposicao, data_hora, 
    ANY_VALUE(regime) AS regime,  -- Conforme analisado em 12/ago/2019, só existe um regime distinto.
    -- Agrupamos as informações de uma mesma tramitação num struct:
    ARRAY_AGG(STRUCT(sequencia AS sequencia, 
                     codSituacao AS codSituacao, 
                     codTipoTramitacao AS codTipoTramitacao, 
                     descricaoSituacao AS descricaoSituacao, 
                     descricaoTramitacao AS descricaoTramitacao, 
                     despacho AS despacho, 
                     siglaOrgao AS siglaOrgao, 
                     uriOrgao AS uriOrgao, 
                     url AS url)
                     ) AS evento,
    -- Agregamos as tramitações numa única string para cada tramitação (agrupada por data):
    STRING_AGG(IFNULL(descricaoSituacao, " - "), "; ")   AS situacao_agg,
    STRING_AGG(IFNULL(descricaoTramitacao, " - "), "; ") AS tramitacao_agg,
    STRING_AGG(IFNULL(despacho, " - "), "; ") AS despacho_agg,
    STRING_AGG(IFNULL(siglaOrgao, " - "), "; ") AS orgao_agg,
    -- Contagem de eventos em cada tramitação (agrupada por data):
    COUNT(*) AS n_eventos,
    ANY_VALUE(api_url) AS api_url, -- Por construção, só existe um único api_url distinto. 
    capture_date
  FROM `gabinete-compartilhado.camara_v2_processed.tramitacoes_cleaned` 
  GROUP BY id_proposicao, data_hora, capture_date 
),

-- Tabela de última tramitação para cada proposição --
last AS (
SELECT id_proposicao, 
  ARRAY_AGG(data_hora ORDER BY capture_date, data_hora DESC)[OFFSET(0)] AS data_hora,
  ARRAY_AGG(capture_date ORDER BY capture_date, data_hora DESC)[OFFSET(0)] AS capture_date
  FROM `gabinete-compartilhado.camara_v2_processed.tramitacoes_cleaned` 
  GROUP BY id_proposicao
)

-- Selecionamos da primeira tabela apenas a última tramitação:
SELECT g.* 
FROM grouped AS g INNER JOIN last as l
ON g.id_proposicao = l.id_proposicao 
AND g.data_hora = l.data_hora 
AND g.capture_date = l.capture_date