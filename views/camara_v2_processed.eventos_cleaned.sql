-- Limpa a tabela 'eventos' (ignora campos vazios e parseia datas) --

SELECT
  -- Identificadores do evento:
  id AS id_evento,
  PARSE_DATETIME('%Y-%m-%dT%H:%M', dataHoraInicio) AS data_hora_inicio,
  IF(CHAR_LENGTH(dataHoraFim)<1, NULL, PARSE_DATETIME('%Y-%m-%dT%H:%M', dataHoraFim)) AS data_hora_fim,
  localCamara.nome AS local_camara_nome,
  -- localCamara.andar é sempre vazio.
  -- localCamara.predio é sempre vazio.
  -- localCamara.sala é sempre vazio.
  -- Descricao do evento:
  situacao,
  descricao,
  descricaoTipo AS descricao_tipo,
  -- Informações sobre a captura:
  uri AS uri_evento,
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,
  api_url
  
FROM `gabinete-compartilhado.camara_v2.eventos` 
