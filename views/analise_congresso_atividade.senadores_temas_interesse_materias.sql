/***
    Tabela de proposições apresentadas pelos parlamentares que possuem temas associados
    - Aqui consideramos como autor das matérias apenas o primeiro autor.
    - Se essa matéria não possui um assunto, buscamos o assunto da matéria associada.
    - Ainda podemos obter o assunto de uma tabela de classificação manual.
    - O assunto final é um desses 3, na ordem de precedência apresentada.
    
    PS:
    - Embora cada proposição só tenha, no máximo, um tema associado a ela,
      a proposição 1 pode ter várias proposições relacionadas, o que acaba 
      criando múltiplas entradas para uma mesma proposição 1. Essas múltiplas
      entradas podem ter o mesmo tema ou não.
 ***/

SELECT 
  -- Info do senador:
  s.legislatura,
  s.IdentificacaoParlamentar.CodigoParlamentar AS id_parlamentar,
  s.IdentificacaoParlamentar.NomeParlamentar AS nome_parlamentar,
  s.partido_sigla_nova AS sigla_partido,
  s.IdentificacaoParlamentar.UfParlamentar AS uf,
  -- Info da matéria da qual o senador é autor:
  p.Codigo_Materia_1,
  p.Sigla_Subtipo_Materia_1,
  p.Numero_Materia_1,
  p.Ano_Materia_1,
  -- Info da matéria associada:
  p.Codigo_Materia_2,
  p.Sigla_Subtipo_Materia_2,
  p.Numero_Materia_2,
  p.Ano_Materia_2,
  -- Assunto das matérias acima:
  p.Assunto_Especifico_Descricao_1,
  p.assunto_especifico_predito_1,
  p.Assunto_Especifico_Descricao_2,
  p.assunto_especifico_predito_2,
  p.assunto_especifico_manual_1,
  p.assunto_especifico_manual_2,
  -- Assunto final da matéria de autoria (puxando o assunto da relacionada, caso necessário):
  p.Assunto_Especifico_Unificado,
  t.assunto_limpo AS assunto_unificado_limpo,
  -- Ementa das matérias:
  p.Ementa_Materia_1,
  p.Ementa_Materia_2
FROM 
  `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
  LEFT JOIN `gabinete-compartilhado.senado_processed.assunto_materias` AS p
  ON s.IdentificacaoParlamentar.CodigoParlamentar = p.Codigo_Parlamentar
  LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_proposicoes_temas_macrotemas` AS t
  ON p.Assunto_Especifico_Unificado = t.assunto_especifico 

WHERE 
-- Seleções na tabela de assuntos:
p.Codigo_Parlamentar IS NOT NULL
AND p.Sigla_Tipo_Autor IN ('LIDER', 'PARLAMENTAR', 'SENADOR', 'SENADOR_PARTIDO', 'SENADOR_LIDER', 'PRESIDENTE_CN')
AND Assunto_Especifico_Unificado IS NOT NULL