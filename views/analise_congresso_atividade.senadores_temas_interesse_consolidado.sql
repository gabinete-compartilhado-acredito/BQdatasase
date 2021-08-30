/***
    Tabela de temas de interesse dos senadores: para cada parlamentar, apresenta:
    - seu ID (id_parlamentar);
    - seu nome (nome_parlamentar);
    - seu partido (sigla_partido);
    - sua UF (uf);
    - o número de proposições e relatorias apresentadas (n_intervencoes_total);
    - o número total de pares "intervenções-tema" (n_total);
    - o número de anos nos quais apresentou ao menos uma proposição com tema (n_anos_proposicoes);
    - o número de anos nos quais relatou ao menos uma matéria (n_anos_relatorias);
    - e, para cada tema, o número de proposições ou relatorias naquele tema (n_intervencoes).
    
    PS: os temas específicos originais do senado menos comuns foram agrupados em categorias maiores,
    para acabar com elas.
 ***/

-- Tabela que conta, para cada parlamentar, o número de intervenções (proposições) associadas a cada tema:
WITH conta_dep_tema AS (

  -- Tabela que informa, para cada senador e sua proposição de autoria ou relatada, o tema associado e a proposição que informa o tema, até 2a ordem:
  -- (também informa o número de anos nos quais apresentou ao menos uma proposição e o número de anos nos quais ele relatou matérias)
  WITH prop_tema AS (
    SELECT
      legislatura,
      -- Info do senador:
      id_parlamentar, nome_parlamentar, sigla_partido, uf, 
      COUNT(DISTINCT IF(tipo_atividade = 'Matéria', Ano_Materia_1, NULL)) OVER (PARTITION BY id_parlamentar) AS n_anos_proposicoes,
      COUNT(DISTINCT IF(tipo_atividade = 'Parecer', EXTRACT(YEAR FROM data_designacao), NULL)) OVER (PARTITION BY id_parlamentar) AS n_anos_relatorias,
      
      -- Info da proposição de autoria ou relatada:
      tipo_atividade,
      Codigo_Materia_1 AS id_proposicao_autoria, Sigla_Subtipo_Materia_1 AS sigla_tipo_autoria, Numero_Materia_1 AS numero_autoria, Ano_Materia_1 AS ano_autoria,
      -- Info do tema:
      assunto_unificado_limpo AS tema,
      -- Contagem de proposições apresentadas ou relatadas: 
      COUNT(DISTINCT CONCAT(tipo_atividade, CAST(Codigo_Materia_1 AS STRING))) OVER (PARTITION BY id_parlamentar) AS n_proposicoes, 
    
    FROM `gabinete-compartilhado.analise_congresso_atividade.senadores_temas_interesse`
  )

  -- Tabela que conta, para cada parlamentar, o número de intervenções (proposições) associadas a cada tema:
  SELECT 
    pt.id_parlamentar, 
    ANY_VALUE(pt.nome_parlamentar) AS nome_parlamentar, 
    ANY_VALUE(pt.sigla_partido) AS sigla_partido, 
    ANY_VALUE(pt.uf) AS uf, 
    pt.tema,
    -- Número de intervenções no tema:
    COUNT(DISTINCT CONCAT(tipo_atividade, CAST(pt.id_proposicao_autoria AS STRING))) AS n_intervencoes,
    ANY_VALUE(n_proposicoes) AS n_intervencoes_total,
    -- Número de anos nos quais o senador apresentou ao menos uma proposição:
    ANY_VALUE(n_anos_proposicoes) AS n_anos_proposicoes,
    ANY_VALUE(n_anos_relatorias) AS n_anos_relatorias
  FROM prop_tema AS pt
  WHERE legislatura IN (55, 56)
  GROUP BY pt.id_parlamentar, pt.tema
)

-- Adiciona à Tabela acima uma coluna com o número total de intervenções de cada senador:
SELECT 
  id_parlamentar, nome_parlamentar, sigla_partido, uf, tema, n_intervencoes, n_intervencoes_total, 
  SUM(n_intervencoes) OVER (PARTITION BY id_parlamentar) AS n_total, n_anos_proposicoes, n_anos_relatorias
FROM conta_dep_tema 
ORDER BY nome_parlamentar, n_intervencoes DESC