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
    p.Codigo_Materia, p.Descricao_Subtipo_Materia, p.Numero_Materia, p.Ano_Materia, p.Assunto_Especifico_Descricao,
    p.Ementa_Materia, p.Explicacao_Ementa_Materia
  FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p,
  UNNEST(p.Materia_Relacionada) AS rel
  )

  SELECT
  -- Id da matéria:
  p1.Codigo_Materia AS Codigo_Materia_1,
  -- Info da matéria:
  p1.Descricao_Subtipo_Materia AS Descricao_Subtipo_Materia_1, 
  p1.Numero_Materia AS Numero_Materia_1, 
  p1.Ano_Materia AS Ano_Materia_1,
  p1.Ementa_Materia AS Ementa_Materia_1,
  -- INFORMAÇÕES DO AUTOR DA MATÉRIA
  p1.Autoria[OFFSET(0)].SiglaTipoAutor AS Sigla_Tipo_Autor,
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.CodigoParlamentar AS Codigo_Parlamentar,
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.NomeParlamentar AS Nome_Autor, 
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.SexoParlamentar AS Sexo,
  p1.Autoria[OFFSET(0)].IdentificacaoParlamentar.FormaTratamento AS Forma_Tratamento,
  -- Assunto da matéria:
  p1.Assunto_Especifico_Descricao AS Assunto_Especifico_Descricao_1,
  -- Descrição da matéria raiz:
  p2.Codigo_Materia AS Codigo_Materia_2, 
  p2.Descricao_Subtipo_Materia AS Descricao_Subtipo_Materia_2, 
  p2.Numero_Materia AS Numero_Materia_2, 
  p2.Ano_Materia AS Ano_Materia_2,
  p2.Ementa_Materia AS Ementa_Materia_2,
  -- Assunto da matéria raiz:
  p2.Assunto_Especifico_Descricao AS Assunto_Especifico_Descricao_2,
  -- Assunto definido manualmente:
  m.assunto_especifico AS assunto_especifico_manual,
  -- Assunto unificado:
  CASE 
    WHEN p1.Assunto_Especifico_Descricao IS NULL AND p2.Assunto_Especifico_Descricao IS NULL THEN m.assunto_especifico
    WHEN p1.Assunto_Especifico_Descricao IS NULL THEN p2.Assunto_Especifico_Descricao
    ELSE p1.Assunto_Especifico_Descricao
  END AS Assunto_Especifico_Unificado

  FROM 
    `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p1
    LEFT JOIN p2 
    ON p1.Codigo_Materia = p2.rel_codigo_materia 
    LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_manual` AS m
    ON p1.Codigo_Materia = m.id_proposicao
)

-- Seleciona os dados da tabela de temas específicos e adiciona o tema agrupado. 
SELECT t.*, m.assunto_agrupado 
FROM 
  temas AS t
  LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_macrotemas` AS m
  ON t.Assunto_Especifico_Unificado = m.assunto_especifico