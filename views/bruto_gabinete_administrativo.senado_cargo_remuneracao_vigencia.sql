SELECT 
  -- Colunas de nomes:
  n.nome_cargo, 
  -- Colunas da tabela de remuneração:
  r.sigla_cargo, r.data_vigencia, r.valor_basico, r.representacao, r.gratif_desempenho, r.valor_opcao,
  -- Colunas construídas:
  r.valor_basico + r.representacao + r.gratif_desempenho AS valor_total_comissionado

FROM `gabinete-compartilhado.bruto_gabinete_administrativo.senado_comissionados_nome_cargos` AS n
INNER JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_comissionados_remuneracao` AS r
ON n.sigla_cargo = r.sigla_cargo