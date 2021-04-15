/***
    Tabela de temas de interesse dos deputados: para cada parlamentar, apresenta:
    - seu ID (id_deputado);
    - seu nome (ultimoStatus_nome);
    - seu partido (sigla_partido);
    - sua UF (uf);
    - o número total de proposições com temas apresentadas (n_total);
    - o número de anos nos quais apresentou ao menos uma proposição com tema (n_anos_atuacao);
    - e, para cada tema, o número de proposições naquele tema (n_intervencoes).
 ***/

-- Tabela que conta, para cada parlamentar, o número de intervenções (proposições) associadas a cada tema:
WITH conta_dep_tema AS (

  -- Tabela que informa, para cada deputado e sua proposição de autoria, o tema associado e a proposição que informa o tema, até 3a ordem:
  -- (também informa o número de anos nos quais apresentou ao menos uma proposição)
  WITH prop_tema AS (
    SELECT
      ultima_legislatura,
      -- Info do deputado:
      id_deputado, ultimoStatus_nome, sigla_partido, uf, COUNT(DISTINCT ano_1) OVER (PARTITION BY id_deputado) AS n_anos_atuacao, 
      -- Info da proposição de autoria:
      id_prop_1 AS id_proposicao_autoria, sigla_tipo_1 AS sigla_tipo_autoria, numero_1 AS numero_autoria, ano_1 AS ano_autoria,
      -- Info sobre a proposição que informa o tema:
      CASE
        WHEN tema_1 IS NOT NULL THEN id_prop_1
        WHEN tema_2 IS NOT NULL THEN id_prop_2
        ELSE id_prop_3
      END AS id_proposicao_tema,
      CASE
        WHEN tema_1 IS NOT NULL THEN sigla_tipo_1
        WHEN tema_2 IS NOT NULL THEN sigla_tipo_2
        ELSE sigla_tipo_3
      END AS sigla_tipo_tema,
      CASE
        WHEN tema_1 IS NOT NULL THEN numero_1 
        WHEN tema_2 IS NOT NULL THEN numero_2
        ELSE numero_3
      END AS numero_tema,
      CASE
        WHEN tema_1 IS NOT NULL THEN ano_1
        WHEN tema_2 IS NOT NULL THEN ano_2
        ELSE ano_3
      END AS ano_tema,
      CASE
        WHEN tema_1 IS NOT NULL THEN 1
        WHEN tema_2 IS NOT NULL THEN 2
        ELSE 3
      END AS ordem,
      -- Info do tema:
      CASE
        WHEN tema_1 IS NOT NULL THEN tema_1
        WHEN tema_2 IS NOT NULL THEN tema_2
        ELSE tema_3
      END AS tema,
      -- Contagem de proposições apresentadas: 
      COUNT(DISTINCT id_prop_1) OVER (PARTITION BY id_deputado) AS n_proposicoes, 
    
    FROM `gabinete-compartilhado.analise_congresso_atividade.deputados_temas_interesse`
  )

  -- Tabela que conta, para cada parlamentar, o número de intervenções (proposições) associadas a cada tema:
  SELECT 
    pt.id_deputado, 
    ANY_VALUE(pt.ultimoStatus_nome) AS ultimoStatus_nome, 
    ANY_VALUE(pt.sigla_partido) AS sigla_partido, 
    ANY_VALUE(pt.uf) AS uf, 
    pt.tema,
    -- Número de intervenções no tema:
    COUNT(DISTINCT pt.id_proposicao_autoria) AS n_intervencoes,
    ANY_VALUE(n_proposicoes) AS n_intervencoes_total,
    -- Número de anos nos quais o deputado apresentou ao menos uma proposição:
    ANY_VALUE(n_anos_atuacao) AS n_anos_atuacao
  FROM prop_tema AS pt
  WHERE pt.ultima_legislatura = 56
  GROUP BY pt.id_deputado, pt.tema
)

-- Adiciona à Tabela acima uma coluna com o número total de intervenções de cada deputado:
SELECT 
  id_deputado, ultimoStatus_nome, sigla_partido, uf, tema, n_intervencoes, n_intervencoes_total, 
  SUM(n_intervencoes) OVER (PARTITION BY id_deputado) AS n_total, n_anos_atuacao
FROM conta_dep_tema 
ORDER BY ultimoStatus_nome, n_intervencoes DESC