select distinct
 'camara' as casa,
  t1.id,
  t2.sigla_tipo as sigla_tipo,
  t2.numero,
  t2.ano,
  PARSE_DATETIME('%Y-%m-%dT%H:%M', t1.dataHora) as data_hora,
  t1.sequencia,
  t1.siglaOrgao as sigla_orgao,
  t1.uriOrgao as uri_orgao,
  t1.codSituacao as cod_situacao,
  t1.regime as regime,
  t1.descricaoTramitacao as descricao_tramitacao,
  t1.codTipoTramitacao as cod_tipo_tramitacao,
  t1.descricaoSituacao as descricao_situacao,
  t1.despacho,
  t2.ementa,
  t2.nome_autor,
  t2.sigla_partido_autor,
  t2.sigla_uf_autor,
  LOWER(t2.keywords) as keywords,
  t1.url
from 	(SELECT *, CAST(ARRAY_REVERSE(SPLIT(api_url, '/'))[ORDINAL(2)] AS INT64) as id 
      FROM  `gabinete-compartilhado.camara_v2.tramitacoes`) AS t1
left join `gabinete-compartilhado.congresso.proposicoes` AS t2
on t1.id = t2.id
