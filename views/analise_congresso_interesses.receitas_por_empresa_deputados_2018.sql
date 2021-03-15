/***
    Valor total doado aos deputados em 2018, por CNPJ raiz
    
    - Agrupamos as doações por deputado, por setor econômico 
      (grupo_cnae) e pelos oito primeiros 
      dígitos do CNPJ (que ignora diferenciação entre filiais)
      e contabilizamos o total doado por aquela empresa, para 
      o deputado em questão.
      
    Note que doações de uma pessoa física com mais de uma empresa
    serão divididas entre todas as empresas que a pessoa possui.
    
    Note também que filiais com raiz do CNPJ iguais podem ter 
    CNAEs diferentes, de maneira que os valores doados por uma 
    mesma empresa raiz pode estar distribuído por mais de um setor.
 ***/

SELECT
  -- Id do parlamentar:
  d.id as id_parlamentar, 
  ANY_VALUE(d.ultimoStatus_nome) AS nome_parlamentar,
  ANY_VALUE(d.sigla_partido) AS sigla_partido,
  ANY_VALUE(d.uf) AS uf,
  -- Id da empresa doadora:
  IFNULL(SUBSTR(d.cnpj_empresa_doador, 1, 8), 'Sem CNPJ associado') AS raiz_cnpj_empresa_doador,
  a.grupo AS grupo_cnae, 
  ANY_VALUE(IFNULL(d.razao_social_doador, 'Sem CNPJ associado')) AS razao_social_doador,
  -- Valor total doado pela empresa e filiais:
  SUM(d.valor_receita_por_cnae) AS valor_doado
  
FROM 
  `gabinete-compartilhado.analise_congresso_interesses.cnaes_doadores_deputados_2018` AS d
  LEFT JOIN `gabinete-compartilhado.receita_federal.cnaes_agrupamento_de_divisoes` AS a
  ON d.cnae_descricao = a.denom_divisao
GROUP BY id_parlamentar, grupo_cnae, raiz_cnpj_empresa_doador
ORDER BY nome_parlamentar, grupo_cnae, razao_social_doador