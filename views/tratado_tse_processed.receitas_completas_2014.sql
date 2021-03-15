/***
     Tabela com as receitas dos candidatos de 2014. 
     
     Criamos colunas novas com sufixo '_unico' que seleciona 
     o doador originário, se existir, ou o doador direto, caso 
     contrário. 
     
     Também adicionamos uma coluna (tipo_receita) que informa se a 
     receita tem origem privada ou pública (de partidos).
 ***/

WITH receitas_completas AS (
  SELECT *,
    IFNULL(nome_doador_originario_rfb, nome_doador_receita_federal ) AS nome_doador_rfb_unico,
    IFNULL(nome_doador_originario, nome_doador) AS nome_doador_unico,
    IFNULL(cpfcnpj_doador_originario, cpfcnpj_doador) AS cpfcnpj_doador_unico,
    IFNULL(tipo_doador_originario, (CASE WHEN LENGTH(cpfcnpj_doador) = 11 THEN 'F' ELSE 'J' END )) AS tipo_doador_unico,
    IF(cpfcnpj_doador_originario IS NULL, cnae_doador, NULL) AS cnae_doador_unico,  
    data_receita AS data_receita_unico,
    descricao_receita AS descricao_receita_unico,
    valor_receita AS valor_receita_unico
  FROM `gabinete-compartilhado.tratado_tse_processed.receitas_candidatos_2014_cleaned` 
)

SELECT *,
  -- Informa se a receita originária veio de um partido:
  CASE
    WHEN
      nome_doador_rfb_unico NOT LIKE '%DIRETORIO ESTADUAL%'
      AND nome_doador_rfb_unico NOT LIKE '%ELEICAO 2014%'
      AND nome_doador_rfb_unico NOT LIKE '%PARTIDO %'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO NACIONAL%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO REGIONAL%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO ESTADUAL%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO MUNIC%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO D%'
      AND nome_doador_rfb_unico NOT LIKE '%COMISSAO %'
      AND nome_doador_rfb_unico NOT LIKE '%COMITE MUNICIPAL%'
      AND nome_doador_rfb_unico NOT LIKE '%COMITE ESTADUAL%'
      AND nome_doador_rfb_unico NOT LIKE '%SOLIDARIEDADE%'
      AND nome_doador_rfb_unico NOT LIKE '%DEMOCRATAS%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRECAO REGIONAL%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO METROPOLITANO%'
    THEN 'Privada'
    ELSE 'Pública'
  END AS tipo_receita
FROM receitas_completas
