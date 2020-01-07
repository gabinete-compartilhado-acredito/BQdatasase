/*** 
     Tabela com todas as orientações partidárias, buscando incluir as orientações feitas por blocos 
     listados na base bruta de orientações com "...". Também anexamos, nesses casos, informações sobre 
     os blocos.
 
***/

-- Tabela com votações e todas as orientações, com partidos de mesmo orientador (e.g. bloco) em ARRAY:
WITH p_array_matched AS (
  -- Tabela com todas as datas e um array de partidos num mesmo bloco:
  WITH data_blocos AS (
    -- Cria ARRAY de datas que cobrem todos os dados da base de blocos:
    WITH t AS (
      SELECT GENERATE_DATE_ARRAY(MIN(b.data_adesao_partido), CURRENT_DATE()) AS date_array
      FROM `gabinete-compartilhado.camara_v1_processed.deputados_blocos_cleaned` as b
    )

    -- Cria tabela de datas e ids de blocos, acompanhadas de arrays dos partidos que fazem parte do bloco:
    -- PS: Os partidos são considerados no bloco na data de adesão e fora do bloco na data de desligamento.
    --     (existe overlap de um dia em troca de blocos em vários casos)
    SELECT data, b.idBloco, 
      ARRAY_AGG(b.sigla_partido_antiga) AS sigla_partido_antiga,
      ARRAY_AGG(b.sigla_partido_nova) AS sigla_partido_nova,
      ARRAY_AGG(b.siglaBloco) AS sigla_bloco,
      ARRAY_AGG(b.data_adesao_partido) AS data_adesao_partido,
      ARRAY_AGG(IFNULL(b.data_desligamento_partido, DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY))) AS data_desligamento_partido,
      COUNT(DISTINCT b.sigla_partido_nova) AS n_partidos_bloco
    FROM t, UNNEST(t.date_array) AS data, `gabinete-compartilhado.camara_v1_processed.deputados_blocos_cleaned` AS b
    WHERE b.data_adesao_partido <= data AND (b.data_desligamento_partido > data OR b.data_desligamento_partido IS NULL)
    GROUP BY data, b.idBloco
  )
  
  -- Tabela de votações, blocos e orientações, junto com ARRAY de partidos pertencentes ao bloco:
  SELECT v.timestamp, v.cod_sessao, v.sigla_tipo, v.numero, v.ano, v.obj_votacao, v.resumo, v.sigla_original, v.sigla, v.orientacao,
    data_blocos.idBloco, data_blocos.n_partidos_bloco, data_blocos.sigla_partido_nova
  FROM `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_bancada_cleaned` AS v, data_blocos
  WHERE CAST(v.timestamp AS DATE) = data_blocos.data
  AND v.sigla IN UNNEST(data_blocos.sigla_partido_nova)
  AND v.sigla_original LIKE "%...%" -- Apenas inclui orientações de blocos com 3 pontinhos. Demais são incluídas na tabela abaixo.

  UNION ALL -- É preciso juntar com a base original pois o WHERE acima seleciona apenas partidos membros de blocos.
            -- Note que isso gera duplicatas das entradas (além das que talvez apareçam por outros motivos)
  
  -- Tabela com todas as orientações originais da base limpa: 
  SELECT v.timestamp, v.cod_sessao, v.sigla_tipo, v.numero, v.ano, v.obj_votacao, v.resumo, v.sigla_original, v.sigla, v.orientacao,
    NULL, 1, [v.sigla]
  FROM `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_bancada_cleaned` AS v
)

-- Expande ARRAY de partidos para as orientações e elimina repetidos, selecionando as orientações individuais, se repetida.
SELECT
  -- Info da votação:
  p.timestamp, p.cod_sessao, p.sigla_tipo, p.numero, p.ano, p.obj_votacao, p.resumo,
  -- Info do partido:
  q AS sigla_partido,
  -- Info da orientação (pode vir de blocos):
  -- Seleciona a orientação individual se existente.
  ARRAY_AGG(p.sigla_original ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS sigla_original,
  ARRAY_AGG(p.idBloco ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS id_bloco,
  ARRAY_AGG(p.n_partidos_bloco ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS n_partidos_bloco,
  ARRAY_AGG(p.orientacao ORDER BY p.n_partidos_bloco)[OFFSET(0)] AS orientacao,
  -- Padroniza a orientação:
  CASE ARRAY_AGG(p.orientacao ORDER BY p.n_partidos_bloco)[OFFSET(0)]
    WHEN 'Abstenção' THEN 'Liberado'
    ELSE ARRAY_AGG(p.orientacao ORDER BY p.n_partidos_bloco)[OFFSET(0)]
  END AS orientacao_padronizada

FROM p_array_matched AS p, UNNEST(p.sigla_partido_nova) as q

GROUP BY p.timestamp, p.cod_sessao, p.sigla_tipo, p.numero, p.ano, p.obj_votacao, p.resumo, sigla_partido


