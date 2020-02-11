SELECT 
  LPAD(CAST(cnpj AS STRING), 14, '0') AS cnpj,
  cnpj AS cnpj_int,
  cnae_ordem,
  LPAD(CAST(cnae AS STRING), 7, '0') AS cnae,
  cnae AS cnae_int

FROM `gabinete-compartilhado.receita_federal.cnaes_secundarias`
order by cnae desc limit 100