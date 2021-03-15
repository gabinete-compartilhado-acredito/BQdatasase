/***
    Tabela de CNAEs associados a doações privadas a senadores nas eleições de 2014
    
    Note que essa tabela só inclui os senadores ELEITOS em 2014. Existem senadores 
    presentes na legislatura 56 que foram eleitos em 2018.
    
    - Criamos uma tabela auxiliar que retorna os CNAes associados a uma pessoa listada na 
      tabela de sócios de empresas (um por empresa, o CNAE principal).
    - Selecionamos os senadores eleitos na legislatura 56 e juntamos com os seus doadores.
        - Se o doador já possui um CNAE na tabela de receitas, usamos esse CNAE;
        - Caso contrário, se é uma empresa, usamos o CNAE dessa empresa;
        - Caso contrário (i.e. é pessoa física), buscamos as empresas das quais ela é sócia e utilizamos o CNAE dela.
        A última coluna de descrição do CNAE segue essa hierarquia.     
 ***/ 

WITH cnaes_dos_socios AS (
  -- Tabela de CNAEs associados a cada sócio --
  SELECT 
    -- Info do sócio:
    s.nome_socio, s.cnpj_cpf_socio, 
    -- Info da empresa (com CNAE principal, chamado fiscal):
    s.cnpj, e.razao_social, e.nome_fantasia, e.cnae_fiscal,
    -- Denominação do CNAE principal:
    IFNULL(d.denom_secao, 'Desconhecido') AS cnae_descricao_macro, 
    IFNULL(d.denom_divisao, 'Desconhecido') AS cnae_descricao,
    -- # de linhas para cada sócio:
    COUNT(e.cnae_fiscal) OVER (PARTITION BY s.nome_socio, s.cnpj_cpf_socio) AS n_entradas_cnae

  FROM 
    `gabinete-compartilhado.receita_federal.socios_cleaned` AS s
    LEFT JOIN `gabinete-compartilhado.receita_federal.empresas_cleaned` AS e
    ON s.cnpj = e.cnpj
    LEFT JOIN `gabinete-compartilhado.receita_federal.cnaes_denominacoes_cleaned` AS d
    ON e.cnae_fiscal = d.cnae_str
)


-- Cruzamento dos deputados atuais com as doações:
SELECT 
  -- Info dos deputados:
  p.id_parlamentar, p.nome_parlamentar, p.nome_candidato, p.nome_completo_parlamentar, p.sigla_partido, p.uf,
  -- Info do doador:
  r.nome_doador_unico, r.nome_doador_rfb_unico, r.cpfcnpj_doador_unico AS cpf_cnpj_doador_unico,
  -- Info da doação:
  NULL AS sequencial_receita, r.data_receita_unico, r.descricao_receita_unico, r.valor_receita_unico,
  -- Indo da empresa associada à doação:
  IF(LENGTH(r.cpfcnpj_doador_unico) = 14, r.cpfcnpj_doador_unico, s.cnpj) AS cnpj_empresa_doador,
  IF(LENGTH(r.cpfcnpj_doador_unico) = 14, r.nome_doador_rfb_unico, s.razao_social) AS razao_social_doador,
  -- CNAE Direto:
  r.cnae_doador_unico,
  cnae_1.denom_secao AS descricao_macro_doador_unico,
  cnae_1.denom_divisao AS descricao_doador_unico,
  -- CNAE da empresa:
  empr.cnae_fiscal AS cnae_doador_pj,
  cnae_2.denom_secao AS descricao_macro_doador_pj,
  cnae_2.denom_divisao AS descricao_doador_pj,
  -- CNAE do sócio:
  s.cnpj AS cnpj_empresa_socio,
  s.razao_social AS razao_social_socio,
  s.nome_fantasia AS nome_empresa_socio,
  s.cnae_fiscal AS cnae_socio,
  s.cnae_descricao_macro AS descricao_macro_socio,
  s.cnae_descricao As descricao_socio,
  -- CNAE final:
  IFNULL(r.cnae_doador_unico, IFNULL(empr.cnae_fiscal, s.cnae_fiscal)) AS cnae,
  IFNULL(IFNULL(cnae_1.denom_secao, IFNULL(cnae_2.denom_secao, s.cnae_descricao_macro)), 'Sem CNPJ associado') AS cnae_descricao_macro,
  IFNULL(IFNULL(cnae_1.denom_divisao, IFNULL(cnae_2.denom_divisao, s.cnae_descricao)), 'Sem CNPJ associado') AS cnae_descricao,
  -- Valor por linha:
  IFNULL(s.n_entradas_cnae, 1) AS n_entradas_cnae,
  r.valor_receita_unico / IFNULL(s.n_entradas_cnae, 1) AS valor_receita_por_cnae


FROM 
  `gabinete-compartilhado.senado_processed.senadores_leg56_cpf_tse` AS p
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2014` AS r 
  ON p.cpf_candidato_str = r.cpf_candidato
  -- Junta denominação CNAE direto no CNAE do doador:
  LEFT JOIN `gabinete-compartilhado.receita_federal.cnaes_denominacoes_cleaned` AS cnae_1
  ON r.cnae_doador_unico = cnae_1.cnae_str
  -- Junta denominação CNAE da empresa doadora:
  LEFT JOIN `gabinete-compartilhado.receita_federal.empresas_cleaned` AS empr
  ON r.cpfcnpj_doador_unico = empr.cnpj AND LENGTH(r.cpfcnpj_doador_unico) = 14 
  LEFT JOIN `gabinete-compartilhado.receita_federal.cnaes_denominacoes_cleaned` AS cnae_2
  ON empr.cnae_fiscal = cnae_2.cnae_str
  -- Junta denominação CNAE das empresas dos sócios:
  LEFT JOIN cnaes_dos_socios AS s
  ON (r.nome_doador_rfb_unico = s.nome_socio OR r.nome_doador_unico = s.nome_socio) 
  AND SUBSTR(r.cpfcnpj_doador_unico, 4, 6) = SUBSTR(s.cnpj_cpf_socio, 4, 6)
  AND LENGTH(r.cpfcnpj_doador_unico) = 11 
  
WHERE p.legislatura = 55 AND r.tipo_receita = 'Privada'

--ORDER BY p.nome_parlamentar, r.nome_doador_rfb_unico, s.cnpj 
order by rand()
