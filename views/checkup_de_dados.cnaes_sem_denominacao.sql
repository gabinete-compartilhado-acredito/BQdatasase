/***
      Testa a existência de códigos CNAEs presentes na tabela de CNPJ de empresas
      mas que não constam na tabela de denominações. O resultado dessa query 
      deveria ser nulo. Se aparecerem códigos CNAEs aqui, é possível resolver o 
      problema modificando a view cnaes_denominacoes_cleaned incluindo esses CNAEs
      em listas lá.
      
      Note que ignoramos casos nos quais o CNAE da empresa é 8888888, que parece 
      significar "CNAE ausente".
 ***/

SELECT DISTINCT e.cnae_fiscal

FROM 
  `gabinete-compartilhado.receita_federal.empresas_cleaned` AS e
  LEFT JOIN `gabinete-compartilhado.receita_federal.cnaes_denominacoes_cleaned` AS d
  ON e.cnae_fiscal = d.cnae_str

WHERE d.cnae_str IS NULL
and e.cnae_fiscal != '8888888'