SELECT * FROM `gabinete-compartilhado.senado_processed.assunto_materias` 
WHERE (Sigla_Tipo_Autor = 'SENADOR' OR Sigla_Tipo_Autor = 'LIDER') AND (Forma_Tratamento IS NOT NULL OR Sexo IS NOT NULL)