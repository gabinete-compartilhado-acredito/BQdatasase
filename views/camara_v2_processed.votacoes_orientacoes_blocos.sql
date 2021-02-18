/*** 
     TABELA DE ORIENTAÇÕES A PARTIR DOS DADOS DE VOTAÇÕES DA V2 DA API DA CÂMARA
     Tabela com todas as orientações partidárias, buscando incluir as orientações feitas por blocos 
     listados na base bruta de orientações com "...". Também anexamos, nesses casos, informações sobre 
     os blocos.
***/

-- Tabela com votações e todas as orientações, com partidos de mesmo orientador (e.g. bloco) em ARRAY:
WITH p_array_matched AS (

  -- Tabela com partidos listados nos nomes dos blocos expandidos e com todas as siglas novas:
  WITH expanded_bloco AS (
    
    -- Adiciona uma coluna às votações das bancadas com array de partidos no bloco:
    WITH d AS (
      SELECT
        vd.data_tramitacao_resultante,
        o.*,
        -- Cria array de partidos dos blocos:
        CASE
          WHEN o.sigla_partido_bloco LIKE '%/%' THEN SPLIT(o.sigla_partido_bloco, '/')
          WHEN UPPER(o.sigla_partido_bloco) = o.sigla_partido_bloco THEN [o.sigla_partido_bloco]
          WHEN o.sigla_partido_bloco LIKE 'Repr.%'  THEN [REPLACE(o.sigla_partido_bloco, 'Repr.', '')]
          ELSE REGEXP_EXTRACT_ALL(o.sigla_partido_bloco, "([A-Z]+[a-zçã]+B?)") -- Old Joao's expression: ([A-Z]?[^A-Z]+)
        END as sigla_array,
      FROM `gabinete-compartilhado.camara_v2_processed.votacoes_orientacoes_cleaned` AS o
      LEFT JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_cleaned` AS vd
      ON o.id_votacao = vd.id_votacao
    )

    -- Tabela com partidos listados nos nomes dos blocos expandidos e com todas as siglas novas:
    SELECT
      -- Info da votação:
      d.id_votacao,
      d.data_tramitacao_resultante,
      d.id_partido,
      IF(d.tipo_lideranca IS NOT NULL, d.tipo_lideranca, IF(d.id_partido IS NULL, 'B', 'P')) AS tipo_lideranca,
      d.sigla_partido_bloco AS sigla_partido_original,
      n.sigla_nova as sigla_partido,
      d.orientacao,
      --IF(d.uri_partido IS NOT NULL, d.uri_partido, CONCAT('https://dadosabertos.camara.leg.br/api/v2/partidos/', CAST(d.id_partido AS INT64))) AS uri_partido,
      -- Info da captura:
      d.api_url,
      d.capture_date
    -- Expande partidos nos blocos:
    FROM d, UNNEST(d.sigla_array) AS sigla_flattened
    LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS n
    -- Traduz as siglas velhas nas novas:
    ON TRIM(UPPER(REGEXP_EXTRACT(sigla_flattened, "[A-z]*"))) = n.sigla_antiga
  )

  -- Tabela de votações, blocos e orientações, junto com ARRAY de partidos pertencentes ao bloco:
  SELECT 
    -- Dados da votação e orientação:
    expanded_bloco.id_votacao, 
    expanded_bloco.data_tramitacao_resultante, 
    expanded_bloco.id_partido,
    expanded_bloco.tipo_lideranca,
    expanded_bloco.sigla_partido_original,
    expanded_bloco.orientacao,
    expanded_bloco.api_url,
    expanded_bloco.capture_date,
    -- Info dos blocos
    data_blocos.idBloco, 
    data_blocos.n_partidos_bloco, 
    data_blocos.sigla_partido_nova -- (Array de siglas que compõem o bloco)
  FROM 
    expanded_bloco, 
    `gabinete-compartilhado.camara_v1_processed.deputados_blocos_composicao_por_dia` AS data_blocos
  WHERE expanded_bloco.data_tramitacao_resultante = data_blocos.data
  AND expanded_bloco.sigla_partido IN UNNEST(data_blocos.sigla_partido_nova)
  AND expanded_bloco.sigla_partido_original LIKE "%...%" -- Apenas inclui orientações de blocos com 3 pontinhos. Demais são incluídas na tabela abaixo.

  UNION ALL -- É preciso juntar com a base original pois o WHERE acima seleciona apenas partidos membros de blocos.
            -- Note que isso gera duplicatas das entradas (além das que talvez apareçam por outros motivos)
  
  -- Tabela com todas as orientações originais da base limpa: 
  SELECT     
    -- Dados da votação e orientação:
    expanded_bloco.id_votacao, 
    expanded_bloco.data_tramitacao_resultante, 
    expanded_bloco.id_partido,
    expanded_bloco.tipo_lideranca,
    expanded_bloco.sigla_partido_original,
    expanded_bloco.orientacao,
    expanded_bloco.api_url,
    expanded_bloco.capture_date,
    -- Info dos blocos:
    NULL AS idBloco, 
    1 AS n_partidos_bloco, 
    [expanded_bloco.sigla_partido] AS sigla_partido_nova
  FROM expanded_bloco
)

-- Expande ARRAY de partidos em cada bloco para as orientações e elimina repetidos, selecionando as orientações individuais, se repetida.
SELECT
  -- Info da votação:
  p.id_votacao, 
  ANY_VALUE(p.data_tramitacao_resultante) AS data_tramitacao_resultante,
  -- Info da orientação (pode vir de blocos):
  -- Seleciona a orientação individual se existente.
  ARRAY_AGG(p.tipo_lideranca ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS tipo_lideranca,
  ARRAY_AGG(p.sigla_partido_original ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS sigla_partido_original,
  q AS sigla_partido,
  ARRAY_AGG(p.idBloco ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS id_bloco,
  ARRAY_AGG(p.n_partidos_bloco ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS n_partidos_bloco,
  ARRAY_AGG(p.orientacao ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS orientacao,
  -- Padroniza a orientação:
  CASE ARRAY_AGG(p.orientacao ORDER BY p.n_partidos_bloco)[OFFSET(0)]
    WHEN 'Abstenção' THEN 'Liberado'
    ELSE ARRAY_AGG(p.orientacao ORDER BY p.n_partidos_bloco)[OFFSET(0)]
  END AS orientacao_padronizada,
  -- Info da captura:
  ANY_VALUE(api_url) AS api_url,
  ANY_VALUE(capture_date) AS capture_date

FROM p_array_matched AS p, UNNEST(p.sigla_partido_nova) as q

GROUP BY p.id_votacao, sigla_partido