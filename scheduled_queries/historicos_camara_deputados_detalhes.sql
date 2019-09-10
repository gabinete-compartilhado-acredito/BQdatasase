# destination_table: historicos.camara_deputados_detalhes

/*** Atualizações no ultimoStatus dos deputados_detalhes ***/

-- Cria uma tabela com ultimoStatus atualizados:
WITH novidades AS (

  -- Tabela de ultimoStatus atual --
  SELECT 
    -- Data das informações:
    PARSE_DATETIME('%Y-%m-%dT%H:%M', atual.ultimoStatus.data) AS data_ultimoStatus, 
    -- Informações sobre o parlamentar:
    atual.id, atual.ultimoStatus.nomeEleitoral, atual.ultimoStatus.nome, atual.ultimoStatus.siglaPartido, atual.ultimoStatus.siglaUf, 
    atual.ultimoStatus.situacao, atual.ultimoStatus.descricaoStatus,
    atual.ultimoStatus.condicaoEleitoral, atual.ultimoStatus.idLegislatura, atual.ultimoStatus.uri, atual.ultimoStatus.uriPartido,
    atual.ultimoStatus.urlFoto,
    -- Informações sobre o gabinete:
    atual.ultimoStatus.gabinete.andar AS gabinete_andar, atual.ultimoStatus.gabinete.email AS gabinete_email, 
    atual.ultimoStatus.gabinete.nome AS ganinete_nome, atual.ultimoStatus.gabinete.predio AS gabinete_predio, 
    atual.ultimoStatus.gabinete.sala AS gabinete_sala, atual.ultimoStatus.gabinete.telefone AS gabinete_telefone
  FROM `gabinete-compartilhado.camara_v2.deputados_detalhes` AS atual

  EXCEPT DISTINCT -- Remove os resultados da tabela abaixo:

  -- Tabela de ultimoStatus guardado no histórico --
  SELECT 
    -- Data das informações:
    hist.data_ultimoStatus, 
    -- Informações sobre o parlamentar:
    hist.id, hist.nomeEleitoral, hist.nome, hist.siglaPartido, hist.siglaUf, 
    hist.situacao, hist.descricaoStatus,
    hist.condicaoEleitoral, hist.idLegislatura, hist.uri, hist.uriPartido,
    hist.urlFoto,
    -- Informações sobre o gabinete:
    hist.gabinete_andar, hist.gabinete_email, 
    hist.ganinete_nome, hist.gabinete_predio, 
    hist.gabinete_sala, hist.gabinete_telefone
  FROM `gabinete-compartilhado.historicos.camara_deputados_detalhes` AS hist  
)

-- Retorna as atualizações, junto com uma coluna da data atual:
SELECT CURRENT_DATE() AS data_gravacao, novidades.* FROM novidades

ORDER BY data_ultimoStatus, id



