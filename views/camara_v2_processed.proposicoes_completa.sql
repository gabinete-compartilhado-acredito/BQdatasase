/***
     Combinação das tabelas de proposições, autores e temas. As informações sobre os autores vem de proposicoes_autores mesmo,
     não de deputados_detalhes. Os autores e temas são agregados em arrays.
***/ 

WITH 

-- Tabela de vetor de autores por proposição, tentando eliminar repetições:
a AS (
  -- Tabela de proposições/autores distintos:
  WITH distinct_props AS (
    SELECT DISTINCT idProposicao, idDeputadoAutor, nomeAutor, sigla_partido, siglaUFAutor
    FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_autores_cleaned`
  )
  -- Agrega autores em vetor por proposição:
  SELECT idProposicao, 
    ARRAY_AGG(idDeputadoAutor IGNORE NULLS ORDER BY idDeputadoAutor) AS id_deputado_autor,
    ARRAY_AGG(nomeAutor IGNORE NULLS ORDER BY idDeputadoAutor) AS nome_autor,
    ARRAY_AGG(sigla_partido IGNORE NULLS ORDER BY idDeputadoAutor) AS sigla_partido_autor,
    ARRAY_AGG(siglaUFAutor IGNORE NULLS ORDER BY idDeputadoAutor) AS uf_autor,
    STRING_AGG(DISTINCT CONCAT(nomeAutor, " (", sigla_partido, "-", siglaUFAutor, ")"), ", " 
      ORDER BY CONCAT(nomeAutor, " (", sigla_partido, "-", siglaUFAutor, ")")) AS lista_autores,
    COUNT(DISTINCT idDeputadoAutor) AS n_autores
  FROM distinct_props
  GROUP BY idProposicao
),

-- Tabela de vetor de temas por proposição:
t AS (
  SELECT  id_proposicao, ARRAY_AGG(DISTINCT tema ORDER BY tema) as tema, 
  STRING_AGG(DISTINCT tema, "; " ORDER BY tema) AS lista_temas
  FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` 
  GROUP BY id_proposicao 
)

SELECT
-- Info da proposição:
p.id AS id_proposicao, p.siglaTipo, p.descricaoTipo, p.numero, p.ano, p.data_apresentacao, p.ementa, p.urlInteiroTeor,
-- Info dos autores:
a.id_deputado_autor, a.nome_autor, a.sigla_partido_autor, a.uf_autor, a.lista_autores, n_autores,
-- Info dos temas:
t.tema, t.lista_temas

FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_processed` AS p
LEFT JOIN a ON p.id = a.idProposicao
LEFT JOIN t ON p.id = t.id_proposicao 