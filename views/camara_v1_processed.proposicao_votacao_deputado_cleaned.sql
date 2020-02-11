/*** Arruma e limpa os dados brutos "proposicao_votacao_deputado", 
     sem misturar com outras bases, com exceção das novas siglas dos partidos.
     
     PS: removemos id_deputado = NULL que são senadores (que talvez apareçam por 
     causa de sessões conjuntas do congresso) 
 ***/

SELECT
  -- Info sobre a votação:
  PARSE_DATETIME('%d/%m/%Y %H:%M', CONCAT(v.Data, ' ', v.Hora)) AS timestamp, -- New column.
  v.Data, 
  v.Hora,
  v.codSessao AS cod_sessao,
  SPLIT(SPLIT(SPLIT(v.api_url, '?')[ORDINAL(2)], '&')[ORDINAL(1)], '=')[ORDINAL(2)] AS sigla_tipo,            -- New column.
  CAST(SPLIT(SPLIT(SPLIT(v.api_url, '?')[ORDINAL(2)], '&')[ORDINAL(2)], '=')[ORDINAL(2)] AS INT64) AS numero, -- New column.
  CAST(SPLIT(SPLIT(SPLIT(v.api_url, '?')[ORDINAL(2)], '&')[ORDINAL(3)], '=')[ORDINAL(2)] AS INT64) AS ano,    -- New column.
  v.ObjVotacao AS obj_votacao,
  v.Resumo AS resumo,
  -- Info sobre o deputado:
  v.ideCadastro AS id_deputado,
  TRIM(v.Nome) AS nome,                      -- Cleaned column.
  TRIM(v.Partido) AS sigla_partido_original, -- Cleaned column.
  p.sigla_nova AS sigla_partido,             -- New column.
  TRIM(v.UF) AS uf,                          -- Cleaned column.
  -- O voto do deputado:
  TRIM(v.Voto) AS voto,                      -- Cleaned column.
  -- Info da captura:
  v.api_url,
  v.capture_date
FROM `gabinete-compartilhado.camara_v1.proposicao_votacao_deputado` AS v
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON TRIM(v.Partido) = p.sigla_antiga
WHERE v.ideCadastro IS NOT NULL