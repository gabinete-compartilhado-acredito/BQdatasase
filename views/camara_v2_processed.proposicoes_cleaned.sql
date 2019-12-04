/***
     Tabela limpa de proposições:
     - Colocamos datas em DATETIME, eliminamos colunas vazias e colocamos keywords em minúsculas.
     - Extraímos a id da proposição principal do url da proposição principal.
     - Anos "0" foram substituídos pelo ano da data de apresentação; o ano original ficou na coluna ano_original.
***/

SELECT 
  -- Identificação da proposição:
  id,
  codTipo,
  descricaoTipo,
  siglaTipo,
  numero,
  IF(ano = 0, CAST(SPLIT(dataApresentacao, '-')[OFFSET(0)] AS INT64), ano) AS ano,
  ano AS ano_original,
  -- Info sobre a proposição:
  PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", dataApresentacao) AS data_apresentacao,
  ementa,
  ementaDetalhada,
  LOWER(keywords) as keywords,
  IF(uriPropPrincipal = '', NULL, CAST(ARRAY_REVERSE(SPLIT(uriPropPrincipal, "/"))[OFFSET(0)] AS INT64)) AS id_prop_principal,    
  -- Links:
  uri,
  uriPropPosterior,
  uriPropPrincipal,
  urlInteiroTeor,
  -- Info da captura:
  api_url,
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", capture_date) AS capture_date

-- Todas as entradas são null:
-- codTipoAutor,   
-- idProposicao,    
-- idDeputadoAutor,
-- nomeAutor,      
-- siglaPartidoAutor,
-- siglaUFAutor,
-- tipoAutor,
-- uriAutor,
-- uriPartidoAutor,
-- uriAutores,
-- uriProposicao,
-- statusProposicao.*
FROM `gabinete-compartilhado.camara_v2.proposicoes` 
