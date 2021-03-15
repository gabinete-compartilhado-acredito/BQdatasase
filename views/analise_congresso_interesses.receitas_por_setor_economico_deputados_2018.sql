/***
    Tabela de receita eleitoral 2018 privada, agregada por setor econômico, por deputado.
 ***/

SELECT 
  -- Id do parlamentar:
  d.id AS id_parlamentar, 
  ANY_VALUE(d.ultimoStatus_nome) AS nome_parlamentar, 
  ANY_VALUE(d.sigla_partido) AS sigla_partido, 
  ANY_VALUE(d.uf) AS uf, 
  -- Setor econômico:
  a.grupo AS grupo_cnae,
  -- Valor e número de doadores:
  SUM(d.valor_receita_por_cnae) AS valor_total, 
  COUNT(DISTINCT CONCAT(d.nome_doador_rfb_unico, d.cpf_cnpj_doador_unico)) AS n_doadores
FROM 
  `gabinete-compartilhado.analise_congresso_interesses.cnaes_doadores_deputados_2018` AS d
  LEFT JOIN `gabinete-compartilhado.receita_federal.cnaes_agrupamento_de_divisoes` AS a
  ON d.cnae_descricao = a.denom_divisao 
GROUP BY id, grupo