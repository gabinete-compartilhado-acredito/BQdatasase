-- TABELA VERIFICADA: SENADOR_SERVIDORES_REMUNERACAO --
-- Verifica se algum servidor aparece duplicado, seja por estar duplicado já na 
-- base de servidores ou por uma repetição de chaves
-- em algum JOIN. Se aparecerem linhas, isso indica esse problema.

-- Tabela de servidores duplicados na tabela com joins.
SELECT capture_date, setor_exercicio, nome_comissionado, nome_funcao, COUNT(*) AS n, 'Duplicado na view após JOINs' AS fonte_do_problema
FROM `gabinete-compartilhado.senado_processed.senador_servidores_remuneracao`
GROUP BY capture_date, setor_exercicio, nome_comissionado, nome_funcao
HAVING n > 1

UNION ALL

-- Tabela de servidores duplicados na base fonte (cleaned) de servidores:
SELECT capture_date, setor_exercicio, nome_comissionado, nome_funcao, COUNT(*) AS n, 'Duplicado já na base de servidores' AS fonte_do_problema
FROM `gabinete-compartilhado.senado_processed.pessoas_servidores_cleaned`
WHERE UPPER(setor2) LIKE '%GABSEN%'
GROUP BY capture_date, setor_exercicio, nome_comissionado, nome_funcao 
HAVING n > 1

ORDER BY n DESC
