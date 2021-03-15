/***
    Tabela de denominações (descrição) dos CNAEs.
    -- Adicionamos uma coluna extra com o código CNAE sem traços ou barras, apenas com números.
    -- Criamos linhas novas para subclasses que estavam faltando. Essas subclasses replicam os
       dados da classe correspondente. A lista de subclasses faltando é definina no código SQL
       abaixo.
***/

SELECT REGEXP_REPLACE(subclasse, r'[.\-/]', '') AS cnae_str, * 
FROM `gabinete-compartilhado.receita_federal.cnaes_denominacoes`

UNION DISTINCT

-- Casos de cnaes com final '00' que estão faltando:
-- Nós utilizamos como subclasse a classe:
SELECT DISTINCT 
  CONCAT(REGEXP_REPLACE(classe, r'[.\-/]', ''), '00') AS cnae_str, secao, divisao, grupo, classe, CONCAT(classe, '/00') AS subclasse,
  denom_secao, denom_divisao, denom_grupo, denom_classe, denom_classe AS denom_subclasse

FROM `gabinete-compartilhado.receita_federal.cnaes_denominacoes`
WHERE REGEXP_REPLACE(classe, r'[.\-/]', '') IN ('10911', '47512', '99008', '35115', '18229', '25390', '30911', '58123') -- Coloque aqui as classes com subclasses '00' faltando.

UNION DISTINCT

-- Casos de cnaes com final '01' que estão faltando:
-- Nós utilizamos como subclasse a classe:
SELECT DISTINCT 
  CONCAT(REGEXP_REPLACE(classe, r'[.\-/]', ''), '01') AS cnae_str, secao, divisao, grupo, classe, CONCAT(classe, '/01') AS subclasse,
  denom_secao, denom_divisao, denom_grupo, denom_classe, denom_classe AS denom_subclasse

FROM `gabinete-compartilhado.receita_federal.cnaes_denominacoes`
WHERE REGEXP_REPLACE(classe, r'[.\-/]', '') IN ('47211', '96092') -- Coloque aqui as classes com subclasses '01' faltando.