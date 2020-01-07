/***
     Tabela com todos os votos de todos os deputados, junto (LEFT JOIN) com as orientações de todos os partidos
     (ou governo, etc.). O apoio é calculado: outras metodologias podem ser adicionadas como novas colunas.
     
     NOTA: a ausência orientada por obstrução é considerada apoio, mesmo que essa orientação venha de um partido 
     que não o do deputado. Demais ausências são ignoradas (NULL). Para cálculo de apoio ao governo, 
     levar em conta como presença quando o deputado se ausenta e seu partido obstruiu (ou seja, presença é quando o apoio
     ao próprio partido é não-nulo). 
***/

SELECT 
  -- Info da votação:
  v.timestamp, v.cod_sessao, v.sigla_tipo, v.numero, v.ano, v.obj_votacao, v.resumo,
  -- Info da proposição:
  -- v.id_proposicao, v.ementa, v.id_autor, v.nome_autor, v.sigla_partido_autor, v.uf_autor, v.url_inteiro_teor,
  -- Info do voto:
  v.id_deputado, v.nome, v.sigla_partido, v.uf, v.voto_padronizado, v.orientacao_proprio_partido, v.voto_orientado,
  -- Info da orientação:
  o.sigla_partido as partido_orientacao, o.orientacao_padronizada,
  -- Cálculo do apoio:
  CASE
    WHEN o.orientacao_padronizada IS NULL OR v.voto_padronizado IS NULL THEN NULL             -- Não existe informação suficiente.
    WHEN v.voto_padronizado = 'Art. 17' THEN NULL                                             -- Presidente não vota.
    WHEN o.orientacao_padronizada = 'Liberado' THEN NULL                                      -- Ignoramos falta de orientação no cálculo do apoio.
    WHEN v.voto_padronizado = 'Ausente' AND o.orientacao_padronizada != 'Obstrução' THEN NULL -- Ignoramos quando o parlamentar está ausente...
    WHEN v.voto_padronizado = 'Ausente' AND o.orientacao_padronizada = 'Obstrução' THEN 1     -- ... a menos que tenha sido orientada obstrução.  
    WHEN v.voto_padronizado = o.orientacao_padronizada THEN 1                                 -- Com exceção desses casos, votos iguais significa apoio.
    ELSE 0
  END AS apoio,
  -- Cálculo do apoio ao próprio partido:
  CASE
    WHEN v.orientacao_proprio_partido IS NULL OR v.voto_padronizado IS NULL THEN NULL             -- Não existe informação suficiente.
    WHEN v.voto_padronizado = 'Art. 17' THEN NULL                                                 -- Presidente não vota.
    WHEN v.orientacao_proprio_partido = 'Liberado' THEN NULL                                      -- Ignoramos falta de orientação no cálculo do apoio.
    WHEN v.voto_padronizado = 'Ausente' AND v.orientacao_proprio_partido != 'Obstrução' THEN NULL -- Ignoramos quando o parlamentar está ausente...
    WHEN v.voto_padronizado = 'Ausente' AND v.orientacao_proprio_partido = 'Obstrução' THEN 1     -- ... a menos que tenha sido orientada obstrução.  
    WHEN v.voto_padronizado = v.orientacao_proprio_partido THEN 1                                 -- Com exceção desses casos, votos iguais significa apoio.
    ELSE 0
  END AS apoio_proprio_partido,
  

-- Todos os votos de todos os deputados, mesmo quando eles faltam:
FROM `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_deputado_orientado` AS v
-- Junta com as orientações de todos os partidos (e gov, etc.), para cada votação:
LEFT JOIN `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_bancada_blocos` as o
ON v.timestamp = o.timestamp 
AND v.cod_sessao = o.cod_sessao
AND v.sigla_tipo = o.sigla_tipo 
AND v.numero = o.numero 
AND v.ano = v.ano
AND v.obj_votacao = o.obj_votacao
AND v.resumo = o.resumo 

/*
-- Para visualizar melhor, mas provavelmente deixa a query mais lenta:
ORDER BY
  timestamp, cod_sessao, sigla_tipo, numero, ano, obj_votacao, resumo,
  id_deputado, partido_orientacao
*/