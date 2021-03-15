/***
    Cruzamento dos dados do TSE com os de senadores do Senado presentes na legislatura 56.
    A tabela extrai, para os senadores e suplentes presentes na 56a legislatura (os senadores
    podem ter sido eleitos para a legislatura 55), as seguinte informações da base de 
    dados do TSE:
    - # sequencial do candidato;
    - Sigla do partido na eleição;
    - Nome de urna do candidato;
    - CPF;
    - Titulo de eleitor.
    
    Encontramos os dados para todos os senadores, menos para a Margareth Gettert Busetti 
    (que é suplente). Esta foi eleita em eleição suplementar em 2020.
 ***/

-- Tabela de candidatos a senador (e suplentes) nas eleições de 2014 e 2018 que foram eleitos:
-- (também incluímos o caso de situracao_tot_turno nula pois um senador não estava dando match).
WITH sen_eleitos AS (
  SELECT 
    ds_cargo, sq_candidato, sg_uf, nome_candidato, nome_urna_candidato, cpf_candidato_str, titulo_eleitoral_candidato_str,
    situacao_tot_turno, situacao_candidatura, detalhe_situacao_cand, sigla_partido_original

  FROM `gabinete-compartilhado.tratado_tse_processed.consulta_candidatos_cleaned`
  WHERE part_ano IN (2018, 2014) 
  AND ds_cargo IN ('1º SUPLENTE', '2º SUPLENTE', 'SENADOR')
  AND (situacao_tot_turno = 'ELEITO' OR (situacao_tot_turno IS NULL AND situacao_candidatura = 'APTO'))
)

-- Tabela de cruzamento de dados entre senado e TSE:
SELECT 
  -- Dados do senado:
  IdentificacaoParlamentar.CodigoParlamentar AS id_parlamentar,
  IdentificacaoParlamentar.NomeParlamentar AS nome_parlamentar,
  s.IdentificacaoParlamentar.NomeCompletoParlamentar AS nome_completo_parlamentar,
  uf_ultimo_mandato AS uf,
  partido_sigla_nova AS sigla_partido,
  s.legislatura as legislatura,
  -- Dados do TSE:
  e.ds_cargo, 
  e.sq_candidato, 
  e.sigla_partido_original AS sigla_partido_eleicao, 
  e.sg_uf, 
  e.nome_candidato, e.nome_urna_candidato, 
  e.cpf_candidato_str, e.titulo_eleitoral_candidato_str
  
FROM `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
LEFT JOIN sen_eleitos As e
-- Join no estado:
ON e.sg_uf = s.uf_ultimo_mandato 
-- Join no nome:
AND 
  (
  REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(s.IdentificacaoParlamentar.NomeCompletoParlamentar), '[ÁÀÂÃÄ]', 'A'), '[ÉÊẼËÈ]', 'E'), 'Í', 'I'), '[ÓÔÕÖ]', 'O'), 'Ú', 'U'), 'Ç', 'C'), '-', ' ') = REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(e.nome_candidato, '[ÁÀÂÃÄ]', 'A'), '[ÉÊẼËÈ]', 'E'), 'Í', 'I'), '[ÓÔÕÖ]', 'O'), 'Ú', 'U'), 'Ç', 'C'), '-', ' ')
  OR
  REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(s.IdentificacaoParlamentar.NomeParlamentar), '[ÁÀÂÃÄ]', 'A'), '[ÉÊẼËÈ]', 'E'), 'Í', 'I'), '[ÓÔÕÖ]', 'O'), 'Ú', 'U'), 'Ç', 'C'), '-', ' ') = REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(e.nome_candidato, '[ÁÀÂÃÄ]', 'A'), '[ÉÊẼËÈ]', 'E'), 'Í', 'I'), '[ÓÔÕÖ]', 'O'), 'Ú', 'U'), 'Ç', 'C'), '-', ' ') 
  OR
  REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(s.IdentificacaoParlamentar.NomeParlamentar), '[ÁÀÂÃÄ]', 'A'), '[ÉÊẼËÈ]', 'E'), 'Í', 'I'), '[ÓÔÕÖ]', 'O'), 'Ú', 'U'), 'Ç', 'C'), '-', ' ') = REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(e.nome_urna_candidato, '[ÁÀÂÃÄ]', 'A'), '[ÉÊẼËÈ]', 'E'), 'Í', 'I'), '[ÓÔÕÖ]', 'O'), 'Ú', 'U'), 'Ç', 'C'), '-', ' ')
)

-- Restringimos aos presentes na legislatura 56:
WHERE s.legislatura IN (55, 56)

