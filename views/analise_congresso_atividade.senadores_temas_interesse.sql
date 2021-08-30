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

SELECT 'Matéria' AS tipo_atividade, 
legislatura, id_parlamentar, nome_parlamentar, sigla_partido, uf, NULL AS data_designacao, Codigo_Materia_1, Sigla_Subtipo_Materia_1, Numero_Materia_1, Ano_Materia_1, Codigo_Materia_2, Sigla_Subtipo_Materia_2, Numero_Materia_2, Ano_Materia_2, Assunto_Especifico_Descricao_1, assunto_especifico_predito_1, Assunto_Especifico_Descricao_2, assunto_especifico_predito_2, assunto_especifico_manual_1, assunto_especifico_manual_2, Assunto_Especifico_Unificado, assunto_unificado_limpo, Ementa_Materia_1, Ementa_Materia_2 

FROM `gabinete-compartilhado.analise_congresso_atividade.senadores_temas_interesse_materias` 

UNION ALL

SELECT 'Parecer' AS tipo_atividade,
legislatura, id_parlamentar, nome_parlamentar, sigla_partido, uf, data_designacao, Codigo_Materia_1, Sigla_Subtipo_Materia_1, Numero_Materia_1, Ano_Materia_1, Codigo_Materia_2, Sigla_Subtipo_Materia_2, Numero_Materia_2, Ano_Materia_2, Assunto_Especifico_Descricao_1, assunto_especifico_predito_1, Assunto_Especifico_Descricao_2, assunto_especifico_predito_2, assunto_especifico_manual_1, assunto_especifico_manual_2, Assunto_Especifico_Unificado, assunto_unificado_limpo, Ementa_Materia_1, Ementa_Materia_2 

FROM `gabinete-compartilhado.analise_congresso_atividade.senadores_temas_interesse_relatorias`