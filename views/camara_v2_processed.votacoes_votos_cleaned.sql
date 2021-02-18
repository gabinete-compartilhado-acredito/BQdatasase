/***
    Tabela de votos dos deputados, limpa.
    -- Criamos uma coluna com o id da votação, a partir do URL da api;
    -- Colocamos coluna nova com a sigla do partido padronizada;
    -- Parseamos a data de registro do voto e a data de captura;
    -- Removemos, por precaução, espaços em branco nas strings;
    -- Colocamos cada item do struct sobre os deputados em uma coluna.
 ***/

SELECT 

-- Info da votação:
ARRAY_REVERSE(SPLIT(v.api_url, '/'))[OFFSET(1)] AS id_votacao,
IF(LENGTH(v.dataRegistroVoto) = 0, NULL, PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", v.dataRegistroVoto)) AS data_registro_voto,

-- Info do deputado:
v.deputado_.id AS id_deputado,
v.deputado_.idLegislatura AS legislatura, 
TRIM(v.deputado_.nome) AS nome_deputado,
v.deputado_.siglaPartido AS sigla_partido_original,
p.sigla_nova AS sigla_partido,
TRIM(v.deputado_.siglaUf) AS sigla_uf, 
TRIM(v.deputado_.email) AS email_deputado, 

-- Voto:
v.tipoVoto AS voto,

-- URIs:
v.deputado_.uri AS uri_deputado, 
v.deputado_.uriPartido AS uri_partido, 
v.deputado_.urlFoto AS url_foto_deputado, 

-- Info da captura: 
v.api_url,
PARSE_DATETIME("%Y-%m-%d %H:%M:%S", v.capture_date) AS capture_date

FROM `gabinete-compartilhado.camara_v2.votacoes_votos` AS v
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON TRIM(v.deputado_.siglaPartido) = p.sigla_antiga 
