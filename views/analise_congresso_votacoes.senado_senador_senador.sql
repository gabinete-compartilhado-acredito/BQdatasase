/***
    Calcula o alinhamento entre senadores, levando em conta votações de 2019 em diante.
    Votos secretos, abstenções e ausências são ignorados no cálculo;
 ***/

SELECT 
  -- Info da votação:
  t1.num_votacao,
  t1.DataSessao,
  t1.DescricaoVotacao,
  t1.DescricaoResultado,
  t1.votacaoSecreta,
  t1.tipoMateria,
  t1.NumeroMateria,
  t1.AnoMateria,
  -- Info do senador 1:
  t1.id_senador AS id_senador_1,
  t1.nome_senador AS nome_senador_1,
  t1.partido_senador AS partido_senador_1,
  t1.uf_senador AS uf_senador_1,
  t1.SiglaDescricaoVoto AS voto_original_1,
  t1.voto_simplificado AS voto_simplificado_1,
  -- Info do senador 2:
  t2.id_senador AS id_senador_2,
  t2.nome_senador AS nome_senador_2,
  t2.partido_senador AS partido_senador_2,
  t2.uf_senador AS uf_senador_2,
  t2.SiglaDescricaoVoto AS voto_original_2,
  t2.voto_simplificado AS voto_simplificado_2,
  -- Alinhamento:
  CASE
    -- Sem info sobre posicionamento de um dos senadores:
    WHEN t1.voto_simplificado = 'Votou' OR t2.voto_simplificado = 'Votou' THEN NULL
    WHEN t1.voto_simplificado = 'Abstenção' OR t2.voto_simplificado = 'Abstenção' THEN NULL
    WHEN t1.voto_simplificado = 'Outros' OR t2.voto_simplificado = 'Outros' THEN NULL
    WHEN t1.voto_simplificado IS NULL OR t2.voto_simplificado IS NULL THEN NULL
    -- Com info sobre posicionamento:
    WHEN t1.voto_simplificado = t2.voto_simplificado THEN 1
    ELSE 0
  END AS alinhamento

FROM `gabinete-compartilhado.congresso.senado_senador_votacoes` AS t1
CROSS JOIN `gabinete-compartilhado.congresso.senado_senador_votacoes` AS t2
-- Linka dados dentro das mesmas votações:
WHERE t1.num_votacao = t2.num_votacao 

-- Retira auto-correlações:
AND t1.id_senador != t2.id_senador 

-- Restringe às votações desde 2019:
AND t1.DataSessao > '2019-02-01'