/***
     Pegamos a tabela de lideranças limpa e juntamos (stack) (UNION) as informações sobre os 
     líderes, representantes e vice-líderes todos nas mesmas colunas (que estavam separadas 
     em colunas diferentes, na mesma linha para cada data e bloco).
     
     Além disso, a tabela inclui uma coluna com o tipo do cargo (líder, vice-líder ou 
     representante) e a ordem em que o deputado aparece no array (no caso dos vice-líderes; 
     os líderes e representantes tem ordem padronizada em 1).
     
     Também incluímos a sigla padronizada dos partidos.
 ***/

-- Tabela dos líderes --
SELECT
  -- Data e bloco:
  l.data, 
  l.sigla_bloco, 
  l.nome_bloco, 
  -- Info do deputado:
  l.id_lider AS id_deputado, 
  l.nome_lider AS nome_deputado, 
  l.sigla_partido_original_lider AS sigla_partido_original,
  p.sigla_nova AS sigla_partido,
  l.uf_lider AS uf_deputado,
  -- Info do cargo:
  "Líder" AS cargo, 
  1 AS ordem,
  -- Info da captura:
  l.capture_date, 
  l.api_url 
FROM `gabinete-compartilhado.camara_v1_processed.liderancas_cleaned` AS l
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p 
ON l.sigla_partido_original_lider = p.sigla_antiga 
WHERE id_lider IS NOT NULL

UNION ALL

-- Tabela de representantes --
SELECT
  -- Data e bloco:
  l.data, 
  l.sigla_bloco, 
  l.nome_bloco, 
  -- Info do deputado:
  l.id_representante AS id_deputado, 
  l.nome_representante AS nome_deputado, 
  l.sigla_partido_original_representante AS sigla_partido_original,
  p.sigla_nova AS sigla_partido,
  l.uf_representante AS uf_deputado,
  -- Info do cargo:
  "Representante" AS cargo, 
  1 AS ordem,
  -- Info da captura:
  l.capture_date, 
  l.api_url
FROM `gabinete-compartilhado.camara_v1_processed.liderancas_cleaned` AS l
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p 
ON l.sigla_partido_original_representante = p.sigla_antiga 
WHERE id_representante IS NOT NULL

UNION ALL 

-- Tabela dos vice-líderes --
SELECT 
  -- Data e bloco:
  l.data, 
  l.sigla_bloco, 
  l.nome_bloco,
  -- Info do deputado:
  v.ideCadastro AS id_deputado, 
  v.nome AS nome_deputado, 
  v.partido AS sigla_partido_original,
  p.sigla_nova AS sigla_partido,
  v.uf AS uf_deputado, 
  -- Info do cargo:
  "Vice-líder" AS cargo,
  offset_num + 1 AS ordem,
  -- Info da captura:
  l.capture_date, 
  l.api_url
FROM `gabinete-compartilhado.camara_v1_processed.liderancas_cleaned` AS l,
UNNEST(array_vicelider) AS v WITH OFFSET AS offset_num
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p 
ON v.partido = p.sigla_antiga 

