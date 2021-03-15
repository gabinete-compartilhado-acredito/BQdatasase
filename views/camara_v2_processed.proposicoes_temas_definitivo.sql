/***
     Tabela definitiva de temas de proposições da câmara.
     O que fazemos aqui é pegar o tema da própria proposição;
     caso ela não tenha tema, buscamos a proposição principal a
     qual ela se refere e pegamos o tema dessa. Caso esta também 
     não possua tema, pegamos a proposição principal seguinte e 
     o tema desta. 
     
     O tema da proposição de 'id_prop_1' fica sendo 'tema_unico'.
 ***/

SELECT

  -- Tema unico (prioridade à proposição mais próxima na cadeia):
    CASE
      WHEN t1.codTema IS NOT NULL THEN t1.codTema
      WHEN t2.codTema IS NOT NULL THEN t2.codTema
      WHEN t3.codTema IS NOT NULL THEN t3.codTema
    ELSE NULL
    END AS cod_tema_unico,
  CASE
    WHEN t1.tema IS NOT NULL THEN t1.tema
    WHEN t2.tema IS NOT NULL THEN t2.tema
    WHEN t3.tema IS NOT NULL THEN t3.tema
    ELSE NULL
    END AS tema_unico,
    
  -- Info da proposição de 1a ordem:
  p1.id AS id_prop_1, p1.siglaTipo AS sigla_tipo_1, p1.numero AS numero_1, p1.ano AS ano_1, 
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

  -- Ementas: 
  p1.ementa AS ementa_1,
  p2.ementa AS ementa_2,

FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS p1

-- Conecta proposição (1a ordem) a tema:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t1
ON p1.id = t1.id_proposicao

-- Conecta proposição (2a ordem) a tema:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t2
ON p1.id_prop_principal = t2.id_proposicao

-- Cria conexão entre 2a e 3a ordens:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS p2
ON p1.id_prop_principal = p2.id 

-- Conecta proposição (3a ordem) a tema:
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t3
ON p2.id_prop_principal = t3.id_proposicao

--WHERE (t1.tema IS NOT NULL OR t2.tema IS NOT NULL OR t3.tema IS NOT NULL) 
