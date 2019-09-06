/***
     Tabela limpa de proposições:
     Colocamos datas em DATETIME, eliminamos colunas vazias e colocamos keywords em minúsculas.
***/

SELECT 
  -- Identificação da proposição:
  id,
  codTipo,
  descricaoTipo,
  siglaTipo,
  numero,
  ano,
  -- Info sobre a proposição:
  PARSE_DATETIME("%Y-%m-%dT%H:%M:%S", dataApresentacao) AS data_apresentacao,
  ementa,
  ementaDetalhada,
  LOWER(keywords) as keywords,
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