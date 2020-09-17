SELECT
  -- Parece ser uma estrutura hierárquica do organograma:
  TRIM(SETOR1) AS setor1,
  TRIM(SETOR2) AS setor2,
  TRIM(SETOR3) AS setor3,
  TRIM(SETOR4) AS setor4,
  TRIM(SETOR5) AS setor5,
  TRIM(SETOR6) AS setor6,
  TRIM(SETOR7) AS setor7,
  -- Local de exercício do servidor (aqui que aparece o nome dos senadores tanto para pessoal de gabinete quanto do escritório de apoio):
  TRIM(SETOR_EXERCICIO) AS setor_exercicio,
  -- Id do comissionado:
  TRIM(NOME) AS nome_comissionado,
  -- Tipo de cargo:
  TRIM(TIPO_DO_VINCULO) AS tipo_vinculo, 
  --TRIM(CARGO) AS cargo, --Sempre vazias 
  --TRIM(CATEGORIA) AS categoria, -- Sempre vazias
  TRIM(FUNCAO) AS nome_funcao,
  -- Outras infos:
  TRIM(ISENCAO_DO_PONTO) AS isencao_ponto,
  IF(LENGTH(TRIM(AFASTAMENTO)) = 0, NULL, TRIM(AFASTAMENTO)) AS afastamento, 
  -- Data de entrada:
  PARSE_DATE('%d/%m/%Y', TRIM(ADMISSAO)) AS data_admissao, 
  -- Info da captura:
  api_url, 
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date

FROM `gabinete-compartilhado.senado.pessoas_comissionados`
WHERE 
-- Remove linhas completamente vazias:
(LENGTH(setor1) != 0 AND setor2 IS NOT NULL AND setor3 IS NOT NULL AND setor4 IS NOT NULL AND setor5 IS NOT NULL AND setor6 IS NOT NULL AND setor7 IS NOT NULL)