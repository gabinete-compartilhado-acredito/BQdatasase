-- Limpa a tabela 'eventos_pauta' (parseia datas, remove colunas vazias, cria coluna de id_evento, remove linhas repetidas) --

-- Esta tabela lista, para cada evento, os items da pauta. 

SELECT DISTINCT
  -- Info do evento:
  CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[OFFSET(1)] AS INT64) AS id_evento,
  -- Info da pauta:
  ordem AS ordem_pauta,
  proposicao_.id AS proposicao_id,
  proposicao_.codTipo AS proposicao_cod_tipo,
  proposicao_.siglaTipo AS proposicao_sigla_tipo,
  proposicao_.numero AS proposicao_numero,
  proposicao_.ano AS proposicao_ano,
  proposicao_.ementa AS proposicao_ementa,
  proposicao_.uri AS proposicao_uri,
  uriProposicaoRelacionada AS uri_proposicao_relacionada,
  -- uriVotacao é sempre vazio.
  codRegime AS cod_regime,
  regime,
  situacaoItem AS situacao_item,
  -- Info da captura:
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,
  api_url
  
FROM `gabinete-compartilhado.camara_v2.eventos_pauta`

order by id_evento, ordem, proposicao_id, cod_regime, situacao_item desc