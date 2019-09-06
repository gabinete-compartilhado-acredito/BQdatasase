/*** 
     Tabela limpa de deputados:
     Mesmo que deputados_detalhes, mas com nomes de colunas diferentes, coluna de partido com sigla nova,
     datas em DATE ou DATETIME, escolaridade padronizada (coluna nova), nome civil em maiúsculas, 
     struct expandidas.
***/

#standardSQL function to set first letter capital:
-- Currently not used.
--CREATE TEMPORARY FUNCTION capitalize(str STRING) AS ((
--  SELECT IF(UPPER(str) = str,STRING_AGG(CONCAT(UPPER(SUBSTR(word, 1, 1)), LOWER(SUBSTR(word, 2))), ' ' ORDER BY pos), str)
--  FROM UNNEST(SPLIT(str, ' ')) word WITH OFFSET pos
--));

SELECT
  -- Identificadores do parlamentar:
  d.id, 
  d.cpf, 
  d.nomeCivil, 
  UPPER(d.nomeCivil) AS nome_civil,
  d.sexo, 
  d.municipioNascimento, 
  d.ufNascimento,
  PARSE_DATE("%Y-%m-%d", d.dataNascimento) AS data_nascimento,
  -- Outras infos:
  d.escolaridade, 
  CASE d.escolaridade
    WHEN "Secundário" THEN "Médio Completo"
    WHEN "Ginasial" THEN "Fundamental Completo"
    WHEN "Primário Incompleto" THEN "Fundamental Incompleto"
    WHEN "Ensino Fundamental" THEN "Fundamental Completo"
    WHEN "Ensino Técnico" THEN "Médio Completo"
    WHEN "Ensino Médio" THEN "Médio Completo"
    WHEN "Primário" THEN "Fundamental Incompleto"
    WHEN "Secundário Incompleto" THEN "Fundamental Completo" -- Envolve um chute por secundário inclui ensino médio.
    WHEN "Superior" THEN "Superior Completo"
    WHEN "Mestrado" THEN "Mestrado Completo"
    WHEN "Doutorado" THEN "Doutorado Completo"
    WHEN "Pós-Graduação" THEN "Pós-Graduação Completa"
  ELSE d.escolaridade
  END AS escolaridade_nova,
  -- Identificação e Filiações:
  d.ultimoStatus.nome AS ultimoStatus_nome,
  d.ultimoStatus.nomeEleitoral AS ultimoStatus_nome_eleitoral, -- Originalmente (feito pelo João) o nome_parlamentar.
  d.ultimoStatus.siglaPartido AS sigla_partido_original,       -- Originalmente (feito pelo João) sigla_partido_antiga.
  p.sigla_nova AS sigla_partido,
  d.ultimoStatus.siglaUf AS uf,                                -- Originalmente (feito pelo João) sigla_uf.
  -- Último status:
  PARSE_DATETIME("%Y-%m-%dT%H:%M", d.ultimoStatus.data) AS ultimoStatus_data,
  d.ultimoStatus.idLegislatura AS ultima_legislatura,
  d.ultimoStatus.condicaoEleitoral AS ultimoStatus_condicao_eleitoral, 	
  d.ultimoStatus.descricaoStatus AS ultimoStatus_descricao,
  d.ultimoStatus.situacao AS ultimoStatus_situacao,
  -- Info do gabinete:
  d.ultimoStatus.gabinete.predio AS gabinete_predio, 	
  d.ultimoStatus.gabinete.andar AS gabinete_andar, 	
  d.ultimoStatus.gabinete.sala AS gabinete_sala, 	
  d.ultimoStatus.gabinete.telefone AS gabinete_telefone, 
  d.ultimoStatus.gabinete.email AS email, 	
  d.ultimoStatus.gabinete.nome AS gabinete_nome,
  -- Links:
  d.redeSocial,
  d.ultimoStatus.uriPartido AS url_partido, 	
  d.ultimoStatus.urlFoto AS url_foto,
  -- Infos da captura:
  PARSE_DATETIME("%Y-%m-%d %H:%M:%S", d.capture_date) AS capture_date, 	
  d.api_url 	

  -- Colunas repetidas:
  --ultimoStatus.uri AS uri_deputado -- É igual a api_url, 
  -- uri AS uri_copia -- É igual a api_url, 
  -- ultimoStatus.id AS ultimoStatus_id, -- É igual a id. 	

FROM `gabinete-compartilhado.camara_v2.deputados_detalhes` AS d
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON d.ultimoStatus.siglaPartido = p.sigla_antiga 