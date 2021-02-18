/***
  TABELA DE EVENTOS ONDE A PARTICIPAÇÃO DO PARLAMENTAR É/ERA PREVISTA
  - Renomeamos as colunas para deixar mais intuitivo;
  - Parseamos as datas:
  - Criamos coluna com o ID do parlamentar a partir da api_url;
  - Criamos uma coluna que mostra o número de órgãos envolvidos (array orgao), para checagens.
 ***/

SELECT
  -- Info do deputado:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[OFFSET(1)] AS INT64) AS id_deputado, 
  -- Info do evento:
  id AS id_evento, 
  descricaoTipo AS tipo_evento, 
  descricao AS descricao_evento, 
  localCamara.nome AS local,
  situacao AS situacao_evento, 
  PARSE_DATETIME('%Y-%m-%dT%H:%M', dataHoraInicio) AS data_hora_inicio, 
  PARSE_DATETIME('%Y-%m-%dT%H:%M', dataHoraFim) AS data_hora_fim,  
  -- Info dos órgãos:
  ARRAY_LENGTH(orgaos) AS n_orgaos_envolvidos,
  orgaos AS orgaos_envolvidos,
  -- URLs e infos da captura:
  uri AS uri_evento,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date,	
  api_url 	

FROM `gabinete-compartilhado.camara_v2.deputados_eventos`

ORDER BY n_orgaos_envolvidos DESC