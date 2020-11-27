/***
    Distribuição dos eleitores por características, localidades e anos.
    (Dados do TSE).
    -- Para anos com menos informações:
      -- Coloquei código correspondente à faixa etária;
      -- Traduzi nomenclaturas antigas do grau de escolaridade para novas;
      -- Parseei datas e horas e dei cast em inteiros.
 ***/

SELECT
  -- Ano:
  ANO_ELEICAO AS ano_eleicao, 
  -- Localidade:
  SG_UF AS uf, 
  NM_MUNICIPIO AS nome_municipio, 
  CD_MUNICIPIO AS cod_tse_municipio, 
  NR_ZONA AS zona_eleitoral,
  -- Informação sobre situação do município em termos de biometria:
  DS_MUN_SIT_BIOMETRIA AS situacao_biometria, 
  CAST(CD_MUN_SIT_BIOMETRIA AS INT64) AS cod_situacao_biometria, 
  -- Gênero:
  DS_GENERO AS genero, 
  CD_GENERO AS cod_genero, 
  -- Estado civil:
  DS_ESTADO_CIVIL AS estado_civil,
  CAST(CD_ESTADO_CIVIL AS INT64) AS cod_estado_civil, 
  -- Faixa etária:
  DS_FAIXA_ETARIA AS faixa_etaria,
  -- Código de faixa etária extraído da descrição:
  CASE
    -- Linha já contém código da faixa etária:
    WHEN CD_FAIXA_ETARIA IS NOT NULL
      THEN CAST(CD_FAIXA_ETARIA AS INT64)
    -- Faixa:
    WHEN REGEXP_CONTAINS(DS_FAIXA_ETARIA, r'\d{2} a \d{2} anos')
      THEN CAST(REGEXP_REPLACE(DS_FAIXA_ETARIA, r'(\d{2}) a (\d{2}) anos', r'\1\2') AS INT64)
    -- Idade exata:
    WHEN REGEXP_CONTAINS(DS_FAIXA_ETARIA, r'^\d{2} anos$')
      THEN CAST(REGEXP_REPLACE(DS_FAIXA_ETARIA, r'^(\d{2}) anos$', r'\100') AS INT64)
    -- Acima de 79 anos:
    WHEN REGEXP_CONTAINS(DS_FAIXA_ETARIA, r'Superior a 79 anos')
      THEN 7979
    -- Inválido:
    WHEN DS_FAIXA_ETARIA = 'Inválido'
      THEN -3
  END AS cod_faixa_etaria,
  CAST(CD_FAIXA_ETARIA AS INT64) AS cod_faixa_etaria_orig,
  -- Escolaridade:
  REPLACE(REPLACE(DS_GRAU_ESCOLARIDADE, 'PRIMEIRO GRAU', 'ENSINO FUNDAMENTAL'), 'SEGUNDO GRAU', 'ENSINO MÉDIO') AS grau_escolaridade,
  DS_GRAU_ESCOLARIDADE AS grau_escolaridade_orig, 
  CD_GRAU_ESCOLARIDADE AS cod_grau_escolaridade, 
  QT_ELEITORES_PERFIL AS qt_eleitores_perfil,
  -- Métricas (número de eleitores):
  CAST(QT_ELEITORES_BIOMETRIA AS INT64) AS qt_eleitores_biometria, 
  CAST(QT_ELEITORES_DEFICIENCIA AS INT64) AS qt_eleitores_deficiencia, 
  CAST(QT_ELEITORES_INC_NM_SOCIAL AS INT64) AS qt_eleitores_solicit_nome_social,
  -- Coluna de partição por ano:
  part_ano,
  -- Info dos dados:
  PARSE_DATE('%d/%m/%Y', DT_GERACAO) AS dt_geracao,
  PARSE_TIME('%H:%M:%S', HH_GERACAO) AS hh_geracao

FROM `gabinete-compartilhado.tratado_tse.perfil_eleitorado`