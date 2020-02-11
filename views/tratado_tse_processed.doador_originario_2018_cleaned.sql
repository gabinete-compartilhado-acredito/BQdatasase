/***
     Limpamo a base de dados de doadores originários:
     - Parseamos os números, com exceção daqueles que podem começar com zero
       (e.g. CPFs);
     - Parseamos datas e horários;
     - Colocamos nomes dos doadores em maiúsculas para padronizar.
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
DS_ELEICAO AS descricao_eleicao,
CAST(ST_TURNO AS INT64) AS turno_eleicao,

-- Info da prestação de contas:
CAST(SQ_PRESTADOR_CONTAS AS INT64) AS sequencial_prestador_contas,
SG_UF AS sigla_uf_prestador_contas,
PARSE_DATE('%d/%m/%Y', DT_PRESTACAO_CONTAS) AS data_prestacao_contas,
TP_PRESTACAO_CONTAS AS tipo_prestacao_contas,

-- Info do doador originário:
UPPER(NM_DOADOR_ORIGINARIO) AS nome_doador_orig,
UPPER(NM_DOADOR_ORIGINARIO_RFB) AS nome_doador_orig_rfb,
NR_CPF_CNPJ_DOADOR_ORIGINARIO AS cpf_cnpj_doador_orig_str,
TP_DOADOR_ORIGINARIO AS tipo_doador_originario,

-- Info da receita:
CAST(SQ_RECEITA AS INT64) AS sequencial_receita,
PARSE_DATE('%d/%m/%Y', DT_RECEITA) AS data_receita,
DS_RECEITA AS descricao_receita,
VR_RECEITA AS valor_receita

FROM `gabinete-compartilhado.tratado_tse.doador_originario_2018`