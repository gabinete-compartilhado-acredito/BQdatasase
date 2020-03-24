-- Tabela que, para cada matéria relacionada, lista a matéria raiz:
WITH p2 AS (
SELECT rel.IdentificacaoMateria.CodigoMateria as rel_codigo_materia, p.Codigo_Materia, p.Descricao_Subtipo_Materia, p.Numero_Materia, p.Ano_Materia, p.Assunto_Especifico_Descricao
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

-- Assunto da matéria raiz:
p2.Assunto_Especifico_Descricao AS Assunto_Especifico_Descricao_2

FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p1


LEFT JOIN p2 on p1.Codigo_Materia = p2.rel_codigo_materia 

