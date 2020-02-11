/***
     Limpa a base de dados de discursos dos deputados:
     - Incluímos o id do deputado a partir do api_url;
     - Parseamos as datas de início, de final e de captura;
     - Retiramos colunas vazias (com a atualização dos dados, as colunas podem passar a serem preenchidas)
 ***/

SELECT
  -- Id do deputado:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[ORDINAL(2)] AS INT64) AS id_deputado,
  -- Data do discurso:
  PARSE_DATETIME('%Y-%m-%dT%H:%M', dataHoraInicio) AS data_hora_inicio,
  --PARSE_DATETIME('%Y-%m-%dT%H:%M', faseEvento.dataHoraInicio) AS fase_evento_data_hora_inicio, -- É sempre vazio.
  PARSE_DATETIME('%Y-%m-%dT%H:%M', dataHoraFim) AS data_hora_fim,
  --PARSE_DATETIME('%Y-%m-%dT%H:%M', faseEvento.dataHoraFim) AS fase_evento_data_hora_fim, -- É sempre vazio.
  -- Tipo do discurso:
  faseEvento.titulo AS fase_evento,
  tipoDiscurso AS tipo_discurso,
  -- Assunto:
  keywords,
  sumario,
  -- Discurso completo:
  transcricao,
  -- URLs:
  urlTexto AS url_texto,
  -- Info da captura:
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date,
  api_url
  -- uriEvento está sempre vazio,
  -- urlAudio está sempre vazio,
  -- urlVideo está sempre vazio,
FROM `gabinete-compartilhado.camara_v2.deputados_discursos`