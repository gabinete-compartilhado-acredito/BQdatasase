/***
    Tabela de CNAEs associados a doações privadas a deputados federais nas eleições de 2018
    
    - Criamos uma tabela auxiliar que retorna os CNAes associados a uma pessoa listada na 
      tabela de sócios de empresas (um por empresa, o CNAE principal).
    - Selecionamos os deputados presentes na legislatura 56, juntamos com os seus doadores
      e depois juntamos os doadores com as empresas e seus CNAEs.
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
    COUNT(e.cnae_fiscal) OVER (PARTITION BY s.nome_socio, s.cnpj_cpf_socio) AS n_entradas_cnae,

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
  d.id, d.ultimoStatus_nome, d.ultimoStatus_nome_eleitoral, d.nome_civil, d.sigla_partido, d.uf,
  -- Info do doador:
  r.nome_doador_unico, r.nome_doador_rfb_unico, r.cpf_cnpj_doador_unico,
  -- Info da doação:
  r.sequencial_receita, r.data_receita_unico, r.descricao_receita_unico, r.valor_receita_unico,
  -- Info da empresa:
  s.cnpj AS cnpj_empresa_doador,
  s.razao_social AS razao_social_doador,
  s.nome_fantasia AS nome_empresa_doador,
  -- Info do CNAE:
  s.cnae_fiscal AS cnae,
  IFNULL(s.cnae_descricao_macro, 'Sem CNPJ associado') AS cnae_descricao_macro,
  IFNULL(s.cnae_descricao, 'Sem CNPJ associado') AS cnae_descricao,
  IFNULL(s.n_entradas_cnae, 1) AS n_entradas_cnae,
  r.valor_receita_unico / IFNULL(s.n_entradas_cnae, 1) AS valor_receita_por_cnae

FROM 
  `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018` AS r 
  ON d.cpf = CAST(r.cpf_candidato_str AS INT64)
  LEFT JOIN cnaes_dos_socios AS s
  ON (r.nome_doador_rfb_unico = s.nome_socio OR r.nome_doador_unico = s.nome_socio) 
  AND SUBSTR(r.cpf_cnpj_doador_unico, 4, 6) = SUBSTR(s.cnpj_cpf_socio, 4, 6)


WHERE d.ultima_legislatura = 56 AND r.tipo_receita = 'Privada'

ORDER BY d.ultimoStatus_nome, nome_socio, cnpj_cpf_socio, cnpj_empresa_doador  
