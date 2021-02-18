# destination_table: views_publicos.br_imprensa_oficial_dou_2

/* Esta query seleciona as matérias (já limpas) do DOU, seção 2 (edições ordinária e extra), de ontem. */ 
SELECT * FROM `gabinete-compartilhado.executivo_federal_dou.materias_campos_cleaned` 
WHERE (part_secao = '2' OR (part_secao = 'e' AND secao = 2)) 
AND part_data_pub = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) 