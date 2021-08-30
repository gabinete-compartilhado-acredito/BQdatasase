/***
    Tabela de temas das proposições do senado.
    -- Busca o "assunto específico" definido na tabela de detalhes das proposições.
    -- Se não existe, busca por um "assunto específico" em matérias com as quais é relacionada.
    -- Se não encontra o assunto, busca em uma tabela manual de classificação de assuntos de proposições.
    -- Por fim, utiliza o agrupamento de assuntos especificado no Google Sheets para 
       definir um "assunto agrupado".
       
    PS:
    -- Cada matéria pode aparecer mais de uma vez e, eventualmente, com temas diferentes
       (ou iguais, também).
 ***/

-- Tabela de tema obtido de três fontes: matéria em si, matéria raiz e classificação manual:
WITH temas AS (

  -- Tabela que, para cada matéria relacionada, lista a matéria raiz:
  WITH p2 AS (
  SELECT 
    rel.IdentificacaoMateria.CodigoMateria as rel_codigo_materia, 
    p.Codigo_Materia, p.Descricao_Subtipo_Materia, p.Sigla_Subtipo_Materia, p.Numero_Materia, p.Ano_Materia, p.Assunto_Especifico_Descricao,
    p.Ementa_Materia, p.Explicacao_Ementa_Materia
  FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p,
  UNNEST(p.Materia_Relacionada) AS rel
  )

  SELECT
  -- Id da matéria:
  p1.Codigo_Materia AS Codigo_Materia_1,
  -- Info da matéria:
  p1.Descricao_Subtipo_Materia AS Descricao_Subtipo_Materia_1,
  p1.Sigla_Subtipo_Materia AS Sigla_Subtipo_Materia_1,
  p1.Numero_Materia AS Numero_Materia_1, 
  p1.Ano_Materia AS Ano_Materia_1,
  p1.Ementa_Materia AS Ementa_Materia_1,
  -- INFORMAÇÕES DO AUTOR DA MATÉRIA (Consideramos apenas o primeiro autor, na ordem oficial do Senado):
  p1.Autoria[OFFSET(0)].SiglaTipoAutor AS Sigla_Tipo_Autor,
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.CodigoParlamentar AS Codigo_Parlamentar,
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.NomeParlamentar AS Nome_Autor, 
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.SexoParlamentar AS Sexo,
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.FormaTratamento AS Forma_Tratamento,
  -- Assunto da matéria:
  p1.Assunto_Especifico_Descricao AS Assunto_Especifico_Descricao_1,
  a1.assunto_pred AS assunto_especifico_predito_1,
  m1.assunto_especifico AS assunto_especifico_manual_1,
  -- Descrição da matéria raiz:
  p2.Codigo_Materia AS Codigo_Materia_2, 
  p2.Descricao_Subtipo_Materia AS Descricao_Subtipo_Materia_2,
  p2.Sigla_Subtipo_Materia AS Sigla_Subtipo_Materia_2,
  p2.Numero_Materia AS Numero_Materia_2, 
  p2.Ano_Materia AS Ano_Materia_2,
  p2.Ementa_Materia AS Ementa_Materia_2,
  -- Assunto da matéria raiz:
  p2.Assunto_Especifico_Descricao AS Assunto_Especifico_Descricao_2,
  a2.assunto_pred AS assunto_especifico_predito_2,
  m2.assunto_especifico AS assunto_especifico_manual_2,
  -- Assunto unificado:
  CASE
    WHEN m1.assunto_especifico IS NOT NULL THEN m1.assunto_especifico
    WHEN p1.Assunto_Especifico_Descricao IS NOT NULL THEN p1.Assunto_Especifico_Descricao
    WHEN a1.assunto_pred IS NOT NULL THEN a1.assunto_pred
    WHEN m2.assunto_especifico IS NOT NULL THEN m2.assunto_especifico
    WHEN p2.Assunto_Especifico_Descricao IS NOT NULL THEN p2.Assunto_Especifico_Descricao
    WHEN a2.assunto_pred IS NOT NULL THEN a2.assunto_pred
    ELSE NULL
  END AS Assunto_Especifico_Unificado

  FROM
    -- Proposição principal:
    `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p1
    -- Classificação por machine learning da prop. principal:
    LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_auto` AS a1
    ON p1.Codigo_Materia = a1.Codigo_Materia
    -- Proposição raiz:
    LEFT JOIN p2 
    ON p1.Codigo_Materia = p2.rel_codigo_materia
    -- Classificação por machine learning da prop. raiz:
    LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_auto` AS a2
    ON p2.Codigo_Materia = a2.Codigo_Materia
    -- Classificação manual da prop. principal:
    LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_manual` AS m1
    ON p1.Codigo_Materia = m1.id_proposicao
    -- Classificação manual da prop. raiz:
    LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_manual` AS m2
    ON p2.Codigo_Materia = m2.id_proposicao
)

-- Seleciona os dados da tabela de temas específicos e adiciona o tema agrupado. 
SELECT t.*, m.assunto_agrupado 
FROM 
  temas AS t
  LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_macrotemas` AS m
  ON t.Assunto_Especifico_Unificado = m.assunto_especifico