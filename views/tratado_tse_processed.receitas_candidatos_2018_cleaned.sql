/***
     Limpamos os dados de receitas obtidas dos candidatos:
     - Parseamos os número em números, com exceção daqueles que podem começar com zero
       (e.g. # processo, CNPJs, CPFs);
     - Parseamos datas e horários;
     - Juntamos com colunas de siglas novas para os partidos;
     - Colocamos os nomes dos doadores em letra maiúscula, para padronizar.
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
NM_UE AS unidade_eleitoral,
CAST(ST_TURNO AS INT64) AS turno_eleicao,

-- Info da prestação de contas:
CAST(SQ_PRESTADOR_CONTAS AS INT64) AS sequencial_prestador_contas,
NR_CNPJ_PRESTADOR_CONTA AS cnpj_prestador_conta_str,
SG_UF AS sigla_uf_prestador_contas,
PARSE_DATE('%d/%m/%Y', DT_PRESTACAO_CONTAS) AS data_prestacao_contas,
TP_PRESTACAO_CONTAS AS tipo_prestacao_contas,

-- Info do candidato:
CAST(SQ_CANDIDATO AS INT64) AS sequencial_candidato,
NM_CANDIDATO AS nome_candidato,
CAST(NR_CANDIDATO AS INT64) AS numero_urna_candidato,
NR_CPF_CANDIDATO AS cpf_candidato_str,
NR_CPF_VICE_CANDIDATO AS cpf_vice_candidato_str,
SG_UE AS sigla_unidade_eleitoral_candidato,
-- Info do partido do candidato:
SG_PARTIDO AS sigla_partido_cand_original,
pc.sigla_nova AS sigla_partido_candidato,
CAST(NR_PARTIDO AS INT64) AS numero_partido_candidato,
NM_PARTIDO AS nome_partido_cand_original,
-- Info do cargo:
CAST(CD_CARGO AS INT64) AS codigo_cargo,
DS_CARGO AS cargo,

-- Info do doador:
UPPER(REPLACE(NM_DOADOR, 'Ã£', 'ã')) AS nome_doador,
UPPER(NM_DOADOR_RFB) AS nome_doador_rfb,
NR_CPF_CNPJ_DOADOR AS cpf_cnpj_doador_str,
-- Local do doador:
SG_UF_DOADOR AS sigla_uf_doador,
CAST(CD_MUNICIPIO_DOADOR AS INT64) AS codigo_municipio_doador,
NM_MUNICIPIO_DOADOR AS municipio_doador,
-- Info do doador que é candidato:
CAST(SQ_CANDIDATO_DOADOR AS INT64) AS sequencial_cand_doador,
CAST(NR_CANDIDATO_DOADOR AS INT64) AS numero_urna_cand_doador,
SG_PARTIDO_DOADOR AS sigla_partido_doador_original,
pd.sigla_nova AS sigla_partido_doador,
CAST(NR_PARTIDO_DOADOR AS INT64) AS numero_partido_doador,
NM_PARTIDO_DOADOR AS nome_partido_doador_original,
CD_ESFERA_PARTIDARIA_DOADOR AS codigo_esfera_part_doador,
DS_ESFERA_PARTIDARIA_DOADOR AS esfera_part_doador,
CAST(CD_CARGO_CANDIDATO_DOADOR AS INT64) AS codigo_cargo_cand_doador,
DS_CARGO_CANDIDATO_DOADOR AS cargo_cand_doador,
-- CNAE do doador (se pessoa jurídica):
CAST(CD_CNAE_DOADOR AS INT64) AS codigo_cnae_doador, 
DS_CNAE_DOADOR AS cnae_doador,

-- Info da doação:
CAST(SQ_RECEITA AS INT64) AS sequencial_receita,
NR_DOCUMENTO_DOACAO AS numero_doc_doacao_str,
NR_RECIBO_DOACAO AS numero_recido_doacao,
PARSE_DATE('%d/%m/%Y', DT_RECEITA) AS data_receita,
CAST(CD_FONTE_RECEITA AS INT64) AS codigo_fonte_receita,
DS_FONTE_RECEITA AS fonte_receita,
CAST(CD_ORIGEM_RECEITA AS INT64) AS codigo_origem_receita,
DS_ORIGEM_RECEITA AS origem_receita,
CAST(CD_NATUREZA_RECEITA AS INT64) AS codigo_natureza_receita,
DS_NATUREZA_RECEITA AS natureza_receita,
CAST(CD_ESPECIE_RECEITA AS INT64) AS codigo_especie_receita,
DS_ESPECIE_RECEITA AS especie_receita,
DS_RECEITA AS receita,
VR_RECEITA AS valor_receita

FROM `gabinete-compartilhado.tratado_tse.receitas_candidatos_2018`
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS pc
ON SG_PARTIDO = pc.sigla_antiga
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` AS pd
ON SG_PARTIDO_DOADOR = pd.sigla_antiga