-- Limpa a tabela 'eventos_orgaos' (parseia data de captura) --

-- Essa tabela relaciona a quais órgãos (e.g. comissões) os eventos (e.g. reuniões) pertencem.

SELECT
  -- Info do orgão:
  id AS id_orgao,
  sigla AS sigla_orgao,
  -- Info do evento:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[OFFSET(1)] AS INT64) AS id_evento,
  -- Links:
  uri AS uri_orgao,
  REPLACE(api_url, '/orgaos', '') AS uri_evento,
  -- Info da captura:
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,
  api_url
  
FROM `gabinete-compartilhado.camara_v2.eventos_orgaos`