/***
  TABELA DE ALINHAMENTO DE VOTOS ENTRE DEPUTADOS
  Esta tabela utiliza a base de votações da API v2 e leva em conta que ausências 
  quando o partido orienta pela obstrução é uma obstrução.
  
  A tabela lista as votações onde temos registro de voto para os dois deputados
  (onde presenças sem voto nos levou a voto_orientado = 'Ausente' ou 'Obstrução', 
  a depender da orientação do partido na época).
  
  Votos iguais levam a linhamento 1, e diferentes levam a alinhamento 0, 
  a não ser quando um dos dois votos é 'Abstenção', 'Artigo 17' ou 'Ausente'.
  Nesses casos, o alinhamento é NULL.
 ***/

SELECT 
  -- Info da votação:
  v1.id_votacao,
  v1.sigla_orgao,
  v1.id_evento,
  v1.votos_sim,
  v1.votos_nao,
  v1.votos_outros,
  v1.descricao_resultado,
  -- Info do deputado 1:
  v1.id_deputado AS id_deputado_1,
  v1.nome_deputado AS nome_deputado_1,
  v1.sigla_partido AS sigla_partido_1,
  v1.uf AS sigla_uf_1,
  v1.data_registro_voto AS data_registro_voto_1,
  -- Info do deputado 2:
  v2.id_deputado AS id_deputado_2,
  v2.nome_deputado AS nome_deputado_2,
  v2.sigla_partido AS sigla_partido_2,
  v2.uf AS sigla_uf_2,
  v2.data_registro_voto AS data_registro_voto_2,
  -- Votos e alinhamento entre deputados:
  v1.voto_orientado AS voto_1,
  v2.voto_orientado AS voto_2,
  CASE 
    WHEN v1.voto_orientado IN ('Abstenção', 'Ausente', 'Artigo 17') THEN NULL
    WHEN v2.voto_orientado IN ('Abstenção', 'Ausente', 'Artigo 17') THEN NULL
    WHEN v1.voto_orientado = v2.voto_orientado THEN 1
    ELSE 0
  END AS alinhamento

FROM `gabinete-compartilhado.camara_v2_processed.votacoes_votos_orientados` AS v1
INNER JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_votos_orientados` AS v2
  ON v1.id_votacao = v2.id_votacao
WHERE v1.voto_orientado IS NOT NULL AND v2.voto_orientado IS NOT NULL