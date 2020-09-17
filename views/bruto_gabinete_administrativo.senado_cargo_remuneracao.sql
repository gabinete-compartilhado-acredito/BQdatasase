-- Seleciona a os valores da remuneração de acordo com a última vigência disponível na tabela de remunerações:
WITH w_max AS (
  SELECT *, MAX(data_vigencia) OVER () AS max_data_vigencia
  FROM `gabinete-compartilhado.bruto_gabinete_administrativo.senado_cargo_remuneracao_vigencia` 
)
SELECT * EXCEPT (max_data_vigencia) FROM w_max
WHERE data_vigencia = max_data_vigencia 