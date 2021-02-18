# destination_table: views_publicos.br_imprensa_nacional_dou_3

/* Esta query seleciona as matérias (já limpas) do DOU, seção 3 (edições ordinária e extra), de ontem. */ 
SELECT * FROM `gabinete-compartilhado.executivo_federal_dou.materias_campos_cleaned` 
WHERE (part_secao = '3' OR (part_secao = 'e' AND secao = 3)) 
AND part_data_pub = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) 