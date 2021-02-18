/*** 
     Tabela com todas as orientações partidárias, buscando incluir as orientações feitas por blocos 
     listados na base bruta de orientações com "...". Também anexamos, nesses casos, informações sobre 
     os blocos.
 
***/

-- Tabela com votações e todas as orientações, com partidos de mesmo orientador (e.g. bloco) em ARRAY:
WITH p_array_matched AS (

  -- Tabela de votações, blocos e orientações, junto com ARRAY de partidos pertencentes ao bloco:
  SELECT v.timestamp, v.cod_sessao, v.sigla_tipo, v.numero, v.ano, v.obj_votacao, v.resumo, v.sigla_original, v.sigla, v.orientacao,
    data_blocos.idBloco, data_blocos.n_partidos_bloco, data_blocos.sigla_partido_nova
  FROM 
    `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_bancada_cleaned` AS v, 
    `gabinete-compartilhado.camara_v1_processed.deputados_blocos_composicao_por_dia` AS data_blocos
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


