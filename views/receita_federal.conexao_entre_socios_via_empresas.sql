/***
    Tabela de conexão entre sócios via empresas em comum.
    
    Conectamos os sócios via os CNPJs em comum. Note que 
    nesta tabela existem empresas listadas como sócias.
 ***/

SELECT 
  -- Sócio 1:
  s1.cnpj_cpf_socio AS cnpj_cpf_socio_1, s1.nome_socio AS nome_socio_1,
  -- Sócio 2:
  s2.cnpj_cpf_socio AS cnpj_cpf_socio_2, s2.nome_socio AS nome_socio_2,
  -- Empresas que conectam os dois:
  ARRAY_AGG(DISTINCT SUBSTR(s1.cnpj, 1, 8) ORDER BY SUBSTR(s1.cnpj, 1, 8)) AS cnpjs_sem_filial_comuns,
  ARRAY_AGG(DISTINCT s1.cnpj ORDER BY s1.cnpj) AS cnpjs_comuns,
  -- Número de empresas conectando os dois:
  COUNT(DISTINCT SUBSTR(s1.cnpj, 1, 8)) AS n_cnpjs_sem_filial_comuns,
  COUNT(DISTINCT s1.cnpj) AS n_cnpjs_comuns

FROM 
  `gabinete-compartilhado.receita_federal.socios_cleaned` AS s1
  INNER JOIN `gabinete-compartilhado.receita_federal.socios_cleaned` AS s2
  ON s1.cnpj = s2.cnpj
-- Elimina conexão do sócio com ele mesmo:
WHERE s1.cnpj_cpf_socio != s2.cnpj_cpf_socio AND s1.nome_socio != s2.nome_socio

GROUP BY s1.cnpj_cpf_socio, s1.nome_socio, s2.cnpj_cpf_socio, s2.nome_socio

--ORDER BY s1.nome_socio, s1.cnpj_cpf_socio, s2.nome_socio, s2.cnpj_cpf_socio 