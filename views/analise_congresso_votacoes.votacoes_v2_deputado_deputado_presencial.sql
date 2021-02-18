/*** 
  TABELA DE ALINHAMENTO ENTRE DEPUTADOS (NÃO OTIMIZADA)
  Calculado com dados de votações da API v2 da câmara, mas só levando em conta os votos registrados.
  Isto é: ausências são ignoradas, mesmo quando o partido orienta pela obstrução. Já vimos 
  que isso é menos realista: deputados cujo partido orientou pela obstrução muitas vezes se saem do 
  plenário. Não levar isso em conta (como é feito aqui) superestima o alinhamento desses deputados 
  com os que não obstruíram e subestima o alinhamento entre deputados que obstruíram.
  
  - Os temas associados a cada votação (um array) são todos os temas de todas as proposições afetadas pela votação
    (uma votação pode afetar mais de uma proposição, e uma proposição pode ter mais de um tema).
  - Ao contrário da base de votações da API v1, que indica a ausência do parlamentar com '-', a base da v2 apenas registra 
    o voto dos votantes. Além disso, a base v2 inclui votações simbólicas e de comissões (das quais nem todos os 
    deputados fazem parte). Por isso, não é fácil diferenciar a situação de quando o parlamentar deveria ter votado 
    e não votou com quando o parlamentar não deveria votar. Ou seja: aqui, ausências são ignoradas.
  - Pelo motivo exposto acima, não existe a coluna 'voto_orientado', onde a ausência significa obstrução se o partido
    mandar obstruir.
  - No cálculo do alinhamento, votos iguais resultam em '1' e desiguais, '0', a menos que um dos deputados tenha 
    o voto 'Artigo 17' ou 'Abstenção'. Nesses casos, o alinhamento é NULL.
 ***/

-- Tabela que lista (em um array) os temas afetados por cada votação:
WITH tab_temas AS (
  SELECT 
    p.id_votacao,
    ARRAY_AGG(DISTINCT t.tema IGNORE NULLS ORDER BY tema) AS temas

  FROM `gabinete-compartilhado.camara_v2_processed.votacoes_proposicoes_afetadas` AS p
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_temas_cleaned` AS t
  ON p.id_afetada = t.id_proposicao 
  GROUP BY p.id_votacao
)

SELECT 
  -- Info da votação:
  v1.id_votacao,
  i.id_orgao,
  i.sigla_orgao,
  i.id_evento,
  i.data_tramitacao_resultante,
  i.data_tramitacao_registro,
  t.temas,
  i.votos_sim,
  i.votos_nao,
  i.votos_outros,
  i.descricao_resultado,
  -- Info do deputado 1:
  v1.id_deputado AS id_deputado_1,
  v1.nome_deputado AS nome_deputado_1,
  v1.sigla_partido AS sigla_partido_1,
  v1.sigla_uf AS sigla_uf_1,
  v1.data_registro_voto AS data_registro_voto_1,
  -- Info do deputado 2:
  v2.id_deputado AS id_deputado_2,
  v2.nome_deputado AS nome_deputado_2,
  v2.sigla_partido AS sigla_partido_2,
  v2.sigla_uf AS sigla_uf_2,
  v2.data_registro_voto AS data_registro_voto_2,
  -- Votos e alinhamento entre deputados:
  v1.voto AS voto_1,
  v2.voto AS voto_2,
  CASE 
    WHEN v1.voto IN ('Abstenção', 'Artigo 17') THEN NULL
    WHEN v2.voto IN ('Abstenção', 'Artigo 17') THEN NULL
    WHEN v1.voto = v2.voto THEN 1
    ELSE 0
  END AS alinhamento


FROM `gabinete-compartilhado.camara_v2_processed.votacoes_votos_cleaned` AS v1
INNER JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_votos_cleaned` AS v2
  ON v1.id_votacao = v2.id_votacao
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_cleaned` AS i
  ON v1.id_votacao = i.id_votacao
LEFT JOIN tab_temas AS t
  ON v1.id_votacao = t.id_votacao