/***
 Tabela "completa" de informações sobre eventos (e.g. reuniões em comissões), 
 com exceção de membros presentes (e outras colunas irrelevantes de tabelas incluídas).
 ***/

SELECT
  -- Info do órgão:
  x.id_orgao, x.sigla_orgao, x.nome_orgao, x.tipo_orgao, x.sigla_orgao_all, x.nome_orgao_all,
  -- Info do evento:
  e.id_evento, e.data_hora_inicio, e.data_hora_fim, e.local_camara_nome, e.descricao, e.descricao_tipo, --e.url_documento_pauta,
  -- Info da pauta:
  p.ordem_pauta, p.proposicao_id, p.proposicao_sigla_tipo, p.proposicao_numero, p.proposicao_ano, p.proposicao_ementa, p.regime, p.situacao_item, p.pauta,
  -- Info da captura:
  e.capture_date AS capture_date_eventos, x.capture_date AS capture_date_orgaos, p.capture_date AS capture_date_pauta

FROM `gabinete-compartilhado.camara_v2_processed.eventos_cleaned` AS e
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.eventos_orgaos_agregada` AS x ON e.id_evento = x.id_evento
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.eventos_pauta_agregada` AS p ON e.id_evento = p.id_evento 
