/***
 TABELA PROCESSADA DE VOTOS DE DEPUTADOS (API V2)

 Esta view apresenta os votos dos deputados levando em conta que ausências quando o 
 partido manda obstruir é considerada obstrução (coluna 'voto_orientado').
 
 Para conseguir fazer isso, precisamos primeiro identificar as votações nas quais o 
 parlamentar tinha presença mas não votou (a base de votações da v2 da API não informa 
 isso). Para tanto, combinamos a base de votos dos deputados com a 'deputados_eventos'.
 
 Para conseguir a orientação dada pelo partido (na época da votação) do deputado nos casos 
 em que ele estava ausente, precisamos utilizar a base de detalhes históricos dos deputados,
 já que a 'deputados_detalhes' informa apenas o partido atual.
 
 De posse das ausências e das orientações partidárias, podemos calcular o 'voto_orientado'.
 Esse cálculo se aplica a votações no plenário com votos registrados. Isso porque, nos demais
 casos (votações em comissões e no plenário sem contagem de votos), as votações podem ser 
 simbólicas, de maneira que a falta de registro de voto não significa ausência ou tentativa 
 de obstrução.
 ***/

-- Tabela de votos com NULL para votos faltando e com partido da época do deputado -- 
WITH votos_deputados AS (

  -- Tabelas auxiliares internas -- 
  WITH 

    -- Tabela de datas de mudanças de partidos dos deputados:
    data_partido AS (

      -- Tabela que extrapola o primeiro partido registrado no histórico do deputado para o passado:
      SELECT d.id, PARSE_DATE('%Y-%m-%d', '1900-01-01') AS data_gravacao, ARRAY_AGG(p.sigla_nova ORDER BY d.data_gravacao)[OFFSET(0)] AS sigla_partido,
      ARRAY_AGG(d.siglaPartido ORDER BY d.data_gravacao)[OFFSET(0)] AS sigla_partido_antiga
      FROM `gabinete-compartilhado.historicos.camara_deputados_detalhes` AS d
      LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
      ON d.siglaPartido = p.sigla_antiga 
      GROUP BY id
      -- Junta:
      UNION ALL
      -- Tabela com todas as datas de mudanças de partido registradas no histórico:
      SELECT d.id, d.data_gravacao, p.sigla_nova AS sigla_partido, d.siglaPartido AS sigla_partido_antiga
      FROM `gabinete-compartilhado.historicos.camara_deputados_detalhes` AS d
      LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
      ON d.siglaPartido = p.sigla_antiga
  ),

    -- Tabela de votos que inclui os votos que deveriam ter sido feitos e não foram:
    -- PS: Para comissões, a presença de deputados é meio estranha (às vezes há presença maior do que o número de membros).
    -- Além disso, a falta de registro de voto nominal não necessariamente significa que o parlamentar estava ausente. 
    -- Pode ser que a votação era simbólica.
    votos_com_ausencia AS (

      SELECT 
      IF(i.id_votacao IS NULL, v.id_votacao, i.id_votacao) AS id_votacao,
      IF(e.id_deputado IS NULL, v.id_deputado, e.id_deputado) AS id_deputado,
      i.id_evento,
      IF(i.data_tramitacao_registro IS NULL, v.data_registro_voto, i.data_tramitacao_registro) AS data_registro_voto,
      v.voto 
      FROM
        -- Base de indicação de presença dos deputados em uma votação (para cada votação, indica os deputados com presença):
        -- Alguns id_evento na tabela 'votacoes_votos_cleaned' está como 0. Nesses, casos (e apenas nele), não há match com a tabela 'deputados_eventos_cleaned'.
        (`gabinete-compartilhado.camara_v2_processed.votacoes_cleaned` AS i INNER JOIN  `gabinete-compartilhado.camara_v2_processed.deputados_eventos_cleaned` AS e ON i.id_evento = e.id_evento)
        -- Tabela de votações nominais efetivamente realizadas:
        FULL OUTER JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_votos_cleaned` AS v ON i.id_votacao = v.id_votacao AND e.id_deputado = v.id_deputado
    )

  -- Tabela de votos com NULL para votos faltando e com partido da época do deputado:
  SELECT 
    v.id_votacao, ANY_VALUE(v.id_evento) AS id_evento, v.id_deputado, 
    ANY_VALUE(v.data_registro_voto) AS data_registro_voto,
    -- Seleciona o partido mais recente do deputado dentre os anteriores à votação (ou seja, o da época da votação): 
    ARRAY_AGG(h.sigla_partido ORDER BY h.data_gravacao DESC)[OFFSET(0)] as sigla_partido, 
    ANY_VALUE(v.voto) AS voto
  FROM (votos_com_ausencia AS v LEFT JOIN data_partido AS h ON v.id_deputado = h.id)
  -- Selecionamos apenas registro de partidos anteriores ao voto: 
  WHERE data_gravacao < v.data_registro_voto 
  GROUP BY v.id_votacao, v.id_deputado
)


SELECT 
  -- Info da votação:
  v.id_votacao, v.id_evento, i.sigla_orgao, 
  -- Info do deputado:
  v.id_deputado, d.ultimoStatus_nome AS nome_deputado, d.uf, v.data_registro_voto, 
  -- Orientação:
  o.sigla_partido_original AS orientador, v.sigla_partido, o.orientacao_padronizada, 
  -- Voto do deputado (no plenário, em votações com contagem de votos nas quais o parlamentar tinha presença, o voto NULL vira 'Ausente'):
  IF(v.voto IS NULL AND i.sigla_orgao = 'PLEN' AND i.votos_sim + i.votos_nao + i.votos_outros > 0, 'Ausente', v.voto) AS voto,
  -- Voto do deputado que é considerado obstrução quando o partido assim orienta e o deputado se ausenta:
  CASE
    WHEN v.voto IS NULL AND i.sigla_orgao = 'PLEN' AND i.votos_sim + i.votos_nao + i.votos_outros > 0 AND o.orientacao_padronizada = 'Obstrução' THEN 'Obstrução'
    WHEN v.voto IS NULL AND i.sigla_orgao = 'PLEN' AND i.votos_sim + i.votos_nao + i.votos_outros > 0 THEN 'Ausente'
    ELSE v.voto
  END AS voto_orientado,
  -- Info da votação:
  i.votos_sim, i.votos_nao, i.votos_outros, i.descricao_resultado

FROM 
  -- Base de votos:
  votos_deputados AS v
  -- Base de orientações:
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_orientacoes_blocos` AS o
  ON v.id_votacao = o.id_votacao AND v.sigla_partido = o.sigla_partido 
  -- Base de detalhes das votações:
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_cleaned` AS i
  ON v.id_votacao = i.id_votacao
  -- Base de deputados:
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d
  ON v.id_deputado = d.id



