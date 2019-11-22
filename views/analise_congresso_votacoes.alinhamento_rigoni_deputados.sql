/***
     Tabela de alinhamento médio entre FELIPE RIGONI e demais deputados. 
     - n_votos indica o número de votos válidos utilizados no cálculo do alinhamento;
     - alinhamento é calculado com a metodologia de analise_congresso_votacoes.camara_deputado_deputado;
     - info do deputado_2 é buscado na tabela camara_v2_processed.deputados_detalhes_cleaned para 
       evitar que mudanças de partido/nome afetem a contagem (via agrupamento errado).
 ***/

-- Tabela que calcula o alinhamento médio com o deputado selecionado em WHERE:
WITH alinha_table AS (
  SELECT a.id_deputado_2, COUNT(a.alinhamento) AS n_votos, AVG(a.alinhamento) AS alinhamento 
  FROM `gabinete-compartilhado.analise_congresso_votacoes.camara_deputado_deputado` AS a
  WHERE a.id_deputado_1 = 204371 -- Felipe Rigoni --
  GROUP BY a.id_deputado_2
)

SELECT 
  -- Id do deputado:
  alinha_table.id_deputado_2, 
  d.ultimoStatus_nome AS nome_deputado_2,
  d.sigla_partido AS partido_deputado_2,
  d.uf AS uf_deputado_2,
  -- Info do alinhamento:
  alinha_table.n_votos, 
  alinha_table.alinhamento
  
FROM alinha_table
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d 
ON alinha_table.id_deputado_2 = d.id   

ORDER BY alinhamento DESC