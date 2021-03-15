/***
    Tabela de alinhamento entre senadores, por macrotema.
    Os macrotemas são agrupamentos de temas definidos pelo senado (
    ou manualmente por nós) de acordo com uma tabela no
    Google Sheets.
 ***/
 
SELECT 
  id_senador_1, ANY_VALUE(nome_senador_1) AS nome_senador_1, 
  id_senador_2, ANY_VALUE(nome_senador_2) AS nome_senador_2, 
  tema_agrupado, AVG(alinhamento) AS alinhamento, COUNT(alinhamento) AS total_votacoes
FROM `gabinete-compartilhado.analise_congresso_votacoes.senado_senador_senador` AS v, UNNEST(v.macrotemas) AS tema_agrupado
GROUP BY id_senador_1, id_senador_2, tema_agrupado
ORDER BY nome_senador_1, nome_senador_2, tema_agrupado
