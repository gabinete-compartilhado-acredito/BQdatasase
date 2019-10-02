SELECT 
  -- Info do evento:
  id_evento,
  -- Info agregadas sobre órgãos:
  ARRAY_AGG(id_orgao ORDER BY sigla_orgao) AS id_orgao,
  ARRAY_AGG(sigla_orgao ORDER BY sigla_orgao) AS sigla_orgao,
  ARRAY_AGG(nome_orgao ORDER BY sigla_orgao) AS nome_orgao,
  ARRAY_AGG(apelido_orgao ORDER BY sigla_orgao) AS apelido_orgao,
  ARRAY_AGG(cod_tipo_orgao ORDER BY sigla_orgao) AS cod_tipo_orgao,
  ARRAY_AGG(tipo_orgao ORDER BY sigla_orgao) AS tipo_orgao,
  ARRAY_AGG(uri_orgao ORDER BY sigla_orgao) AS uri_orgao,
  -- Info agregadas em texto:
  STRING_AGG(sigla_orgao, '\n' ORDER BY sigla_orgao) AS sigla_orgao_all,
  STRING_AGG(nome_orgao, '\n' ORDER BY nome_orgao) AS nome_orgao_all,
  -- Info da captura e links:
  uri_evento, api_url, capture_date

FROM `gabinete-compartilhado.camara_v2_processed.eventos_orgaos_cleaned`
GROUP BY id_evento, uri_evento, api_url, capture_date

order by id_evento 