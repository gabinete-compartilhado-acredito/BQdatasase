/***
    Para todos os dias até hoje, esta tabela apresenta todos os blocos em funcionamento nesse dia
    (uma linha por bloco). Cada linha contém informações o dia e o bloco em questão, incluindo 
    arrays de partidos que compõem o bloco.
 ***/

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

