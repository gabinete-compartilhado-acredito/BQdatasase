/***
    -- Tabela de temas de interesse dos deputados --
    
    Para cada deputado, buscamos todas as proposições das quais ele é autor (que chamamos de 1a ordem) 
    e verificamos seu tema. Caso a proposição não tenha um tema, provavelmente ela é um recurso/ementa 
    a uma outra proposição. Nesse caso, buscamos o tema da proposição associada (chamada de "principal" 
    na base, e que chamamos de 2a ordem). Caso essa proposição não tenha tema, buscamos a associada a 
    ela (3a ordem). Por fim, selecionamos apenas as proposições com pelo menos um tema associado, até 
    3a ordem.
 ***/

SELECT 
-- Info do deputado:
d.ultima_legislatura, d.id AS id_deputado, d.ultimoStatus_nome, d.sigla_partido, d.uf,

-- Info da proposição de 1a ordem:
a.idProposicao AS id_prop_1, p1.siglaTipo AS sigla_tipo_1, p1.numero AS numero_1, p1.ano AS ano_1,
p1.ementa AS ementa_1,
-- Tema da proposição de 1a ordem:
t1.codTema AS cod_tema_1, t1.tema AS tema_1,

-- Info da proposição de 2a ordem:
p1.id_prop_principal AS id_prop_2, p2.siglaTipo AS sigla_tipo_2, p2.numero AS numero_2, p2.ano AS ano_2, 
-- Tema da proposição de 2a ordem:
t2.codTema AS cod_tema_2, t2.tema AS tema_2,

-- Info da proposição de 3a ordem:
p2.id_prop_principal AS id_prop_3, t3.siglaTipo AS sigla_tipo_3, t3.numero AS numero_3, t3.ano AS ano_3, 
-- Tema da proposição de 3a ordem:
t3.codTema AS cod_tema_3, t3.tema AS tema_3,

-- Código do tema final (o primeiro não nulo na ordem acima):
CASE
  WHEN t1.codTema IS NOT NULL THEN t1.codTema
  WHEN t2.codTema IS NOT NULL THEN t2.codTema
  WHEN t3.codTema IS NOT NULL THEN t3.codTema
  ELSE NULL
END AS cod_tema_final,
-- Tema final (o primeiro não nulo na ordem acima):
CASE
  WHEN t1.tema IS NOT NULL THEN t1.tema
  WHEN t2.tema IS NOT NULL THEN t2.tema
  WHEN t3.tema IS NOT NULL THEN t3.tema
  ELSE NULL
END AS tema_final

FROM `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d
-- Conecta deputado a proposições (1a ordem) das quais foi autor:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_autores_cleaned` AS a
ON d.id = a.idDeputadoAutor

-- Conecta proposição (1a ordem) a tema:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t1
ON a.idProposicao = t1.id_proposicao

-- Cria conexão entre 1a e 2a ordens:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS p1
ON a.idProposicao = p1.id 

-- Conecta proposição (2a ordem) a tema:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t2
ON p1.id_prop_principal = t2.id_proposicao

-- Cria conexão entre 2a e 3a ordens:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS p2
ON p1.id_prop_principal = p2.id 

-- Conecta proposição (3a ordem) a tema:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t3
ON p2.id_prop_principal = t3.id_proposicao

WHERE (t1.tema IS NOT NULL OR t2.tema IS NOT NULL OR t3.tema IS NOT NULL)

ORDER BY d.ultima_legislatura DESC, id_deputado, id_prop_1, tema_1, id_prop_2, tema_2, id_prop_3, tema_3
