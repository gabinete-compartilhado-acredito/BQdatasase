# destination_table: datastudio.apoio_deputados_governo

-- Table of a unique number for each voting --
WITH r AS (
 -- Table of unique votings --
 WITH u AS (
 SELECT DISTINCT z.timestamp, z.sigla_tipo, z.numero, z.ano, z.obj_votacao, z.resumo, z.url_inteiro_teor
 FROM `gabinete-compartilhado.congresso.camara_votacao_bancada` as z
 )
 -- Add voting numbering:
 SELECT ROW_NUMBER() OVER (ORDER BY u.timestamp, u.sigla_tipo, u.numero, u.ano, u.obj_votacao) AS num_votacao,
 u.timestamp, u.sigla_tipo, u.numero, u.ano, u.obj_votacao, u.resumo, u.url_inteiro_teor
 FROM u
)

-- Add a numbering to the voting and government support table --
SELECT r.num_votacao, v.*, r.url_inteiro_teor
FROM `gabinete-compartilhado.paineis.apoio_ao_governo_por_votacao` as v
LEFT JOIN r 
ON r.timestamp = v.timestamp
AND r.sigla_tipo = v.sigla_tipo
AND r.numero = v.numero 
AND r.ano = v.ano 
AND r.obj_votacao = v.obj_votacao
AND r.resumo = v.resumo
-- Selects only Legislatura 56 onwards: 
WHERE v.timestamp >= '2019-02-01'