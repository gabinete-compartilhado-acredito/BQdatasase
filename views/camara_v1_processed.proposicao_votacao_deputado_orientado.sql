/***
     Essa tabela pega os votos dos deputados (da tabela limpa) e faz três coisas:
     - Padroniza as descrições dos votos dos deputados;
     - Inclui na tabela a orientação dada pelo próprio partido (na época da votação) do deputado;
     - Produz a coluna de voto "orientado", que considera obstruções as ausências quando o partido mandou obstruir.
     
     Essa tabela é uma cópia de proposicao_votacao_deputado_processed, mas sem a remoção de duplicatas
     com capture_dates diferentes (removidas diretamente no data storage em 06/01/2020) e sem informações 
     sobre as proposições.
 ***/

-- Seleciona votos únicos, eliminando repetições com mesma data de captura:
SELECT DISTINCT v.*,
  -- Nova coluna de votos padronizados:
  CASE v.voto
    WHEN 'Branco' THEN 'Abstenção'
    WHEN '-' THEN 'Ausente'
    ELSE v.voto
  END AS voto_padronizado,
  -- Info do próprio partido e voto no qual ausência orientada à obstrução é obstrução:
  b.orientacao_padronizada AS orientacao_proprio_partido,
  CASE
    WHEN (v.voto = 'Ausente' OR v.voto = '-') AND b.orientacao_padronizada = 'Obstrução' THEN 'Obstrução'
    WHEN v.voto = 'Branco' THEN 'Abstenção'
    WHEN v.voto = '-' THEN 'Ausente'
    ELSE v.voto
  END AS voto_orientado
  
FROM `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_deputado_cleaned` AS v

-- Junta com orientações do próprio partido:
LEFT JOIN `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_bancada_blocos` AS b
ON v.timestamp = b.timestamp 
AND v.cod_sessao = b.cod_sessao
AND v.sigla_tipo = b.sigla_tipo 
AND v.numero = b.numero 
AND v.ano = b.ano
AND v.obj_votacao = b.obj_votacao
AND v.resumo = b.resumo
AND v.sigla_partido = b.sigla_partido