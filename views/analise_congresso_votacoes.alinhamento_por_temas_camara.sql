/***
    Tabela de alinhamento entre deputados, por macrotema.
    As votações vêm da API v2, e os macrotemas são agrupamentos
    de temas definidos pela câmara de acordo com uma tabela no
    Google Sheets.
 ***/
 
SELECT nome_deputado_1, nome_deputado_2, tema_agrupado, AVG(alinhamento) AS alinhamento, COUNT(alinhamento) AS total_votacoes
FROM `gabinete-compartilhado.analise_congresso_votacoes.votacoes_v2_deputado_deputado_por_tema` AS v, UNNEST(v.macrotemas) AS tema_agrupado
WHERE nome_deputado_1 != nome_deputado_2
GROUP BY nome_deputado_1, nome_deputado_2, tema_agrupado
ORDER BY nome_deputado_1, nome_deputado_2, tema_agrupado
