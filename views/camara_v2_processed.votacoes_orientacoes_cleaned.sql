/***
    Tabela de orientações partidárias em votações, limpa.
    -- Criamos uma coluna com o id da votação a partir da URL da api;
    -- Parseamos a data de captura.
 ***/

SELECT 

-- Info da votação:
ARRAY_REVERSE(SPLIT(v.api_url, '/'))[OFFSET(1)] AS id_votacao,

codPartidoBloco AS id_partido, 
codTipoLideranca AS tipo_lideranca, 
siglaPartidoBloco AS sigla_partido_bloco, 

-- Orientação:
IF(TRIM(orientacaoVoto) = '', NULL, TRIM(orientacaoVoto)) AS orientacao, 

-- URIs:
uriPartidoBloco AS uri_partido, 

-- Info da captura: 
v.api_url,
PARSE_DATETIME("%Y-%m-%d %H:%M:%S", v.capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.votacoes_orientacoes` AS v
