-- TABELA VERIFICADA: SENADOR_SERVIDORES_REMUNERACAO --
-- Verifica se faltam informações sobre remuneração ou senador. Se aparecerem linhas ao rodar essa view,
-- isso indica que a join entre tabelas de servidores com de senadores ou com de remuneração não está 
-- ocorrendo. Isso pode indicar grafia diferente nas chaves utilizadas:
-- Nome dos senadores;
-- Nome do cargo.

SELECT * 
FROM `gabinete-compartilhado.senado_processed.senador_servidores_remuneracao`
WHERE CodigoParlamentar IS NULL OR sigla_cargo IS NULL
ORDER BY NomeParlamentar