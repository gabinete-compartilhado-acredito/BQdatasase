/***
    Análise do peso dos doadores privados.
    Essa view seleciona doadores que são partidos e totaliza o valor doado
    por eles.
 ***/

-- Tabela com o total doado por pessoa:
WITH doadores AS (
  SELECT nome_doador_rfb_unico, cpf_cnpj_doador_unico, ANY_VALUE(nome_doador_unico) AS nome_doador_unico, 
  COUNT(distinct nome_candidato) AS n_cand, SUM(valor_receita_unico) AS valor_total

  FROM `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018`
  WHERE tipo_receita = 'Privada'

  GROUP BY nome_doador_rfb_unico, cpf_cnpj_doador_unico
  ORDER BY valor_total DESC
)

-- Tabela que calcula a fração do total de doações privadas associado a cada doador:
SELECT *, 
  SUM(valor_total) OVER () AS valor_total_eleicoes, 
  SUM(valor_total) OVER (ORDER BY valor_total DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS valor_cumulativo,
  SUM(valor_total) OVER (ORDER BY valor_total DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(valor_total) OVER () AS fracao_cumulativa,
  valor_total / SUM(valor_total) OVER () AS fracao_do_total
FROM doadores