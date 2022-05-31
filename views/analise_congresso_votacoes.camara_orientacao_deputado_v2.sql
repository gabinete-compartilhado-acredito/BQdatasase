/*** 
    Tabela de alinhamento entre deputados e orientações (API V2)
    
    Nesta tabela, cruzamos os votos feitos por deputados (segundo os dados de votações
    da API v2 da Câmara) com as orientações dadas pelos partidos (e pelo Governo, 
    Oposição, etc.) e calculamos o alinhamento entre os dois. Os votos dos deputados
    já foram corrigidos para o caso no qual o seu partido orienta pela obstrução e o 
    deputado está ausente: isso é considerado obstrução.
    
    Colunas que, juntas, identificam uma única linha:
    id_votacao, id_deputado, orientador.
 ***/


SELECT 
  v.id_votacao, v.id_evento, v.sigla_orgao, v.id_deputado, v.nome_deputado, v.uf, v.sigla_partido, v.data_registro_voto, v.voto AS voto_original, v.voto_orientado, 
  o.sigla_partido AS orientador, o.orientacao_padronizada,
  -- Cálculo do alinhamento:
  CASE
    WHEN TRIM(o.orientacao_padronizada) = '' OR TRIM(v.voto_orientado) = '' THEN NULL -- Sem informações suficientes.
    WHEN o.orientacao_padronizada IS NULL OR v.voto_orientado IS NULL THEN NULL       -- Sem informações suficientes.
    WHEN o.orientacao_padronizada = 'Liberado' THEN NULL                              -- Partido não orientou.
    WHEN v.voto_orientado = 'Artigo 17' THEN NULL                                     -- Presidente não vota (e talvez membros da mesa também não).
    WHEN v.voto_orientado = 'Ausente' THEN NULL                                       -- Ignoramos o caso de parlamentar ausente (voto_orientado já é obstrução quando o partido pede obstrução).
    WHEN v.voto_orientado = o.orientacao_padronizada THEN 1
    ELSE 0
  END AS alinhamento,
  -- Presença ou não:
  IF(v.voto_orientado = 'Sim' OR v.voto_orientado = 'Não' OR v.voto_orientado = 'Abstenção', 1, 0) AS quorum, 
  v.descricao_resultado
  

FROM 
  `gabinete-compartilhado.camara_v2_processed.votacoes_votos_orientados` AS v
  LEFT JOIN `gabinete-compartilhado.camara_v2_processed.votacoes_orientacoes_blocos` AS o
  ON v.id_votacao = o.id_votacao