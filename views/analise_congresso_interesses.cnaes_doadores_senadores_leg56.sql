/***
    Tabela com todos os dados de doações a senadores da legislatura 56
    
    Unimos as tabelas de doações para as eleições de 2014 com as das 
    doações de 2018. Ambas apenas incluem os senadores da legislatura 56.
 ***/


SELECT 
  -- Id do senador:
  id_parlamentar, nome_parlamentar, nome_completo_parlamentar, sigla_partido, uf, 
  -- Id do doador:
  nome_doador_unico, nome_doador_rfb_unico, cpf_cnpj_doador_unico, 
  -- Info da receita:
  sequencial_receita, data_receita_unico, descricao_receita_unico, valor_receita_unico,
  -- Info da empresa associada à doação:
  cnpj_empresa_doador, razao_social_doador,
  -- Info do setor econômico:
  cnae, cnae_descricao_macro, cnae_descricao, 
  -- Valor:
  n_entradas_cnae, valor_receita_por_cnae

FROM `gabinete-compartilhado.analise_congresso_interesses.cnaes_doadores_senadores_2014`

UNION ALL

SELECT 
  -- Id do senador:
  id_parlamentar, nome_parlamentar, nome_completo_parlamentar, sigla_partido, uf, 
  -- Id do doador:
  nome_doador_unico, nome_doador_rfb_unico, cpf_cnpj_doador_unico, 
  -- Info da receita:
  sequencial_receita, data_receita_unico, descricao_receita_unico, valor_receita_unico,
  -- Info da empresa associada à doação:
  cnpj_empresa_doador, razao_social_doador,  
  -- Info do setor econômico:
  cnae, cnae_descricao_macro, cnae_descricao, 
  -- Valor:
  n_entradas_cnae, valor_receita_por_cnae

FROM `gabinete-compartilhado.analise_congresso_interesses.cnaes_doadores_senadores_2018`