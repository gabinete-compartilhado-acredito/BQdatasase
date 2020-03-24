/***
      Limpa a tabela de Requerimentos da legislatura 56, classificados por um 
      modelo de machine learning entre 0 - Outros, 1 - Audiência pública e 
      2 - pedidos de informação.
      
      - Parseia as datas;
      - Traduz o código de classificação do requerimento para uma descrição.
 ***/

SELECT
  id,
  ementa,
  PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", data_apresentacao) AS data_apresentacao,
  predicted_class, 
  CASE predicted_class
    WHEN 0 THEN 'Outros requerimentos'
    WHEN 1 THEN 'Pedidos de audiência pública'
    WHEN 2 THEN 'Pedidos de informação'
  END AS tipo_requerimento,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", process_date) AS process_date

FROM `gabinete-compartilhado.bruto_gabinete_administrativo.requerimentos_classificados_leg56`