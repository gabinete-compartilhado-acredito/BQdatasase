-- Tabela limpa de blocos parlamentares --
-- Fizemos UNNEST nos partidos que compõem os blocos, colocamos as datas como DATE e pegamos as siglas novas dos partidos.

SELECT 
  -- Info dos blocos:
  b.idBloco, b.nomeBloco, b.siglaBloco, 
  PARSE_DATE("%d/%m/%Y", b.dataCriacaoBloco) AS data_criacao_bloco, PARSE_DATE("%d/%m/%Y", b.dataExtincaoBloco) AS data_extincao_bloco,
  -- Info dos partidos que compõem o bloco:
  p.idPartido, p.nomePartido, p.siglaPartido AS sigla_partido_antiga,
  n.sigla_nova AS sigla_partido_nova,
  PARSE_DATE("%d/%m/%Y", p.dataAdesaoPartido) AS data_adesao_partido, 
  PARSE_DATE("%d/%m/%Y", p.dataDesligamentoPartido) AS data_desligamento_partido,
  -- Info da captura:
  api_url, capture_date

FROM `gabinete-compartilhado.camara_v1.deputados_blocos` AS b, UNNEST(b.Partidos.partido) AS p
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` as n
ON p.siglaPartido = n.sigla_antiga 