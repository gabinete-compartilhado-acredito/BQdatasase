/***
    Calcula o alinhamento entre senadores, levando em conta votações de 2019 em diante.
    Votos secretos, abstenções e ausências são ignorados no cálculo;
    Adiciona array com 
 ***/
 
-- Tabela que lista (em um array) os temas afetados por cada votação:
WITH tab_temas AS (
  SELECT 
    a.Codigo_Materia_1 AS id_proposicao,
    ARRAY_AGG(DISTINCT a.Assunto_Especifico_Unificado IGNORE NULLS ORDER BY a.Assunto_Especifico_Unificado) AS temas,
    ARRAY_AGG(DISTINCT a.assunto_agrupado IGNORE NULLS ORDER BY a.assunto_agrupado) AS macrotemas

  FROM `gabinete-compartilhado.senado_processed.assunto_materias` AS a
  GROUP BY a.Codigo_Materia_1
)

SELECT 
  -- Info da votação:
  t1.id_votacao,
  t1.data_sessao,
  t1.descricao_votacao,
  t1.resultado_votacao,
  t1.votacao_secreta,
  t1.id_proposicao,
  t1.sigla_tipo_proposicao,
  t1.num_proposicao,
  t1.ano_proposicao,
  b.temas,
  b.macrotemas,
  -- Info do senador 1:
  t1.id_senador AS id_senador_1,
  t1.nome_senador AS nome_senador_1,
  t1.partido_senador AS partido_senador_1,
  t1.uf_senador AS uf_senador_1,
  t1.descricao_voto AS voto_original_1,
  t1.voto_simplificado AS voto_simplificado_1,
  -- Info do senador 2:
  t2.id_senador AS id_senador_2,
  t2.nome_senador AS nome_senador_2,
  t2.partido_senador AS partido_senador_2,
  t2.uf_senador AS uf_senador_2,
  t2.descricao_voto AS voto_original_2,
  t2.voto_simplificado AS voto_simplificado_2,
  -- Alinhamento:
  CASE
    -- Sem info sobre posicionamento de um dos senadores:
    WHEN t1.voto_simplificado = 'Votou' OR t2.voto_simplificado = 'Votou' THEN NULL
    WHEN t1.voto_simplificado = 'Abstenção' OR t2.voto_simplificado = 'Abstenção' THEN NULL
    WHEN t1.voto_simplificado = 'Outros' OR t2.voto_simplificado = 'Outros' THEN NULL
    WHEN t1.voto_simplificado IS NULL OR t2.voto_simplificado IS NULL THEN NULL
    -- Com info sobre posicionamento:
    WHEN t1.voto_simplificado = t2.voto_simplificado THEN 1
    ELSE 0
  END AS alinhamento

FROM `gabinete-compartilhado.senado_processed.senador_votacoes_simplificado` AS t1
LEFT JOIN tab_temas AS b
ON t1.id_proposicao = b.id_proposicao
CROSS JOIN `gabinete-compartilhado.senado_processed.senador_votacoes_simplificado` AS t2
-- Linka dados dentro das mesmas votações:
WHERE t1.id_votacao = t2.id_votacao 

-- Restringe às votações desde 2019:
AND t1.data_sessao > '2019-01-01'