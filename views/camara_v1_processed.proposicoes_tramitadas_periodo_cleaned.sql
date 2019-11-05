/***
     Limpeza da tabela de tramitações do período.
     - Passamos as colunas de datas apra tipo DATETIME
     - Nesse processo, trocamos M por 30 na capture_date, uma falha da captura antiga;
     - Nesse proceso, as datas de alteração sem hora receberam 00:00:00.
 ***/

SELECT
  -- Info da proposição:
  codProposicao,
  tipoProposicao AS tipo_proposicao,
  numero,
  ano, 
  -- Info sobre a tramitação:
  PARSE_DATETIME('%d/%m/%Y %H:%M:%S', dataAlteracao) AS data_alteracao, -- (provavelmente a data de inscrição no sistema)
  IF(LENGTH(dataTramitacao) > 10, PARSE_DATETIME('%d/%m/%Y %H:%M:%S', dataTramitacao), PARSE_DATETIME('%d/%m/%Y', dataTramitacao)) AS data_tramitacao,
  -- Info da captura:
  api_url, 
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', REPLACE(capture_date, 'M', '30')) AS capture_date
FROM `gabinete-compartilhado.camara_v1.proposicoes_tramitadas_periodo`

--ORDER BY data_tramitacao DESC