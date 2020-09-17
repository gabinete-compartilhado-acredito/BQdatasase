-- TABELA VERIFICADA: SENADOR_SERVIDORES_REMUNERACAO --
-- Verifica se algum servidor aparece duplicado, provavelmente por uma repetição de chaves
-- em algum JOIN. Se aparecerem linhas, isso indica esse problema.
SELECT setor_exercicio, nome_comissionado, nome_funcao, COUNT(*) AS n
FROM `gabinete-compartilhado.senado_processed.senador_servidores_remuneracao`
GROUP BY setor_exercicio, nome_comissionado, nome_funcao
HAVING n > 1
ORDER BY n DESC
