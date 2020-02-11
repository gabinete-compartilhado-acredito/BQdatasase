/***
     Limpamos a base de dados de candidatos das eleições de 2018:
     - Os números foram parseados em números, com exceção daqueles que podem começar com zero
       (CPF, tit. eleitor, NR processo)
     - As datas e horários foram parseados;
     - Colocamos uma coluna extra com o nome atual do partido. 
 ***/

SELECT
-- Info dos dados:
PARSE_DATE('%d/%m/%Y', DT_GERACAO) AS data_geracao,
PARSE_TIME('%H:%M:%S', HH_GERACAO) AS horario_geracao,

-- Info da eleição:
CAST(CD_ELEICAO AS INT64) AS codigo_eleicao,
CAST(ANO_ELEICAO AS INT64) AS ano_eleicao,
PARSE_DATE('%d/%m/%Y', DT_ELEICAO) AS data_eleicao,
CAST(CD_TIPO_ELEICAO AS INT64) AS codigo_tipo_eleicao,
NM_TIPO_ELEICAO AS tipo_eleicao,
TP_ABRANGENCIA AS abrangencia_eleicao,
DS_ELEICAO AS descricao_eleicao,
SG_UF AS sigla_uf, 
SG_UE AS sigla_unidade_eleitoral,
NM_UE AS nome_unidade_eleitoral,
CAST(NR_TURNO AS INT64) AS numero_turno,

-- Info do candidato:
-- Nomes e ids:
CAST(SQ_CANDIDATO AS INT64) AS sequencial_candidato,
NM_CANDIDATO AS nome_completo_candidato,
NM_SOCIAL_CANDIDATO AS nome_social_candidato,
NM_URNA_CANDIDATO AS nome_urna_candidato,
CAST(NR_CANDIDATO AS INT64) AS numero_urna_candidato,
-- Documentos:
NR_CPF_CANDIDATO AS cpf_candidato_str,
NR_TITULO_ELEITORAL_CANDIDATO AS titulo_eleitoral_candidato_str,
-- Nascimento:
SG_UF_NASCIMENTO AS sigla_uf_nascimento,
NM_MUNICIPIO_NASCIMENTO AS municipio_nascimento,
PARSE_DATE('%d/%m/%Y', DT_NASCIMENTO) AS data_nascimento,
CAST(NR_IDADE_DATA_POSSE AS INT64) AS idade_data_posse,
-- Detalhes:
CAST(CD_NACIONALIDADE AS INT64) AS codigo_nacionalidade,
DS_NACIONALIDADE AS nacionalidade,
CAST(CD_GENERO AS INT64) AS codigo_genero,
DS_GENERO AS genero,
CAST(CD_COR_RACA AS INT64) AS codigo_cor_raca,
DS_COR_RACA AS cor_raca,
CAST(CD_ESTADO_CIVIL AS INT64) AS codigo_estado_civil,
DS_ESTADO_CIVIL AS estado_civil,
CAST(CD_GRAU_INSTRUCAO AS INT64) AS codigo_grau_instrucao,
DS_GRAU_INSTRUCAO AS grau_instrucao,
CAST(CD_OCUPACAO AS INT64) AS codigo_ocupacao,
DS_OCUPACAO AS ocupacao,
-- Contato:
NM_EMAIL AS email_candidato,
NM_SITE AS site_candidato,
-- Características na eleição:
ST_REELEICAO AS reeleicao,
ST_DECLARAR_BENS AS bens_a_declarar,

-- Info do partido/coligação:
CAST(SQ_COLIGACAO AS INT64) AS sequencial_coligacao,
TP_AGREMIACAO AS tipo_agremiacao,
NM_COLIGACAO AS nome_coligacao,
DS_COMPOSICAO_COLIGACAO AS composicao_coligacao,
SG_PARTIDO AS sigla_partido_original,
p.sigla_nova AS sigla_partido,
CAST(NR_PARTIDO AS INT64) AS numero_partido,
NM_PARTIDO AS nome_partido,
CAST(REPLACE(NR_DESPESA_MAX_CAMPANHA, ',', '.') AS FLOAT64) AS despesa_max_campanha,

-- Info da candidatura:
NR_PROCESSO AS numero_processo_str,
CAST(CD_CARGO AS INT64) AS codigo_cargo,
DS_CARGO AS cargo,
CAST(CD_SITUACAO_CANDIDATURA AS INT64) AS codigo_situacao_candidatura,
DS_SITUACAO_CANDIDATURA AS situacao_candidatura,
CAST(CD_DETALHE_SITUACAO_CAND AS INT64) AS codigo_detalhe_situacao_cand,
DS_DETALHE_SITUACAO_CAND AS detalhe_situacao_cand,

-- Info do resultado:
CAST(CD_SIT_TOT_TURNO AS INT64) AS codigo_sit_tot_turno,
DS_SIT_TOT_TURNO AS sit_tot_turno

FROM `gabinete-compartilhado.tratado_tse.consulta_cand_2018`
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS p
ON SG_PARTIDO = p.sigla_antiga 