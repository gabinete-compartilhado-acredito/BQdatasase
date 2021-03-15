/***
    Tabela de receita total da campanha de 2018 e número de votos obtidos de cada deputado da legislatura 56.
 ***/

SELECT
  -- Id do deputado:
  d.id, 
  c.sq_candidato, 
  d.cpf, 
  d.ultimoStatus_nome, 
  d.sigla_partido, 
  d.uf, 
  d.nome_civil, 
  c.nome_candidato, 
  -- Receita:
  r.receita_total,
  r.receita_privada,
  r.n_doadores_privados,
  -- Votos:
  v.QT_VOTOS_NOMINAIS AS votos_obtidos,
  -- Custo do voto:
  r.receita_total / CAST(v.QT_VOTOS_NOMINAIS AS FLOAT64) AS custo_voto

FROM
  -- Tabela de deputados:
  `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d
  -- Tabela de candidatos:
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.consulta_candidatos_cleaned` AS c
  ON d.cpf = CAST(c.cpf_candidato_str AS INT64)
  -- Tabela de receitas:
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.total_de_receitas_por_candidato_2018` AS r
  ON c.sq_candidato = r.sequencial_candidato
  -- Tabela de votos:
  LEFT JOIN `gabinete-compartilhado.tratado_tse.total_votos_por_eleicao_cand` AS v
  ON c.sq_candidato = v.SQ_CANDIDATO 
  
WHERE d.ultima_legislatura = 56 AND c.part_ano = 2018 AND c.situacao_candidatura = 'APTO' AND v.ANO_ELEICAO = 2018 
