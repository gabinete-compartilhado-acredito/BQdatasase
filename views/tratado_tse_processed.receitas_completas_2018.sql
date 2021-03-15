/***
     Esta tabela junta as informações das tabelas de receitas dos candidatos com a dos doadores originários (LEFT JOIN).
     Isso quer dizer que, quando existem doadores originários referentes a uma certa receita do candidato, os dados das
     colunas oriundas da tabela de receitas ficam repetidas. Isto é, não se deve somar a coluna valor_receita para determinar 
     o montante doado ou recebido por alguém.
     
     Também criamos colunas que replicam os dados (e valores) das doações originárias ou, na ausência destes, os dados da 
     receita mãe. Ou seja: estas colunas servem como identificadoras únicas das doações: seus valores podem ser somados 
     para representar um total doado ou recebido.
     
     Em seguida, criamos duas colunas que verificam se existem inconsistências entre a soma dos valores originários e o 
     valor da receita mãe (cerca de 3% dos dados não batem).
     
     Por fim, adicionamos uma coluna que classifica a receita em pública (tipicamente vindo de campanhas eleitorais
     ou de partidos) ou privada (de pessoas física ou empresas).
 ***/

WITH receitas_completas AS (
SELECT
  -- Dados das receitas dos candidatos:
  r.*, 
  -- Dados do doador originário:
  o.nome_doador_orig, o.nome_doador_orig_rfb, o.cpf_cnpj_doador_orig_str, o.tipo_doador_originario, 
  o.data_receita AS data_receita_orig, o.descricao_receita AS descricao_receita_orig, o.valor_receita AS valor_receita_orig,
  -- Colunas genéricas sobre doações (usam dados do doador originário se existir, senão a da receita):
  IFNULL(o.nome_doador_orig, r.nome_doador) AS nome_doador_unico,
  IFNULL(o.nome_doador_orig_rfb, r.nome_doador_rfb) AS nome_doador_rfb_unico,
  IFNULL(o.cpf_cnpj_doador_orig_str, r.cpf_cnpj_doador_str) AS cpf_cnpj_doador_unico,
  IFNULL(o.tipo_doador_originario, IF(r.codigo_cnae_doador IS NULL, 'F', 'J')) AS tipo_doador_unico,
  IFNULL(o.data_receita, r.data_receita) AS data_receita_unico,
  IFNULL(o.descricao_receita, r.receita) AS descricao_receita_unico,
  IFNULL(o.valor_receita, r.valor_receita) AS valor_receita_unico,
  -- Somatória das doações originárias (replica valor da receita mãe caso não existam doações originárias):
  IFNULL(ROUND(SUM(o.valor_receita) OVER (PARTITION BY o.sequencial_prestador_contas, o.sequencial_receita), 2), r.valor_receita) AS soma_doacoes_orinarias,
  -- Verifica se soma das doações originárias é aprox. igual ao valor da receita declarada (ou se não existem doações originárias):
  IF(ABS(IFNULL(SUM(o.valor_receita) OVER (PARTITION BY o.sequencial_prestador_contas, o.sequencial_receita), r.valor_receita) - r.valor_receita) < 1, 
    1, 0) AS match_registro_doacoes

FROM `gabinete-compartilhado.tratado_tse_processed.receitas_candidatos_2018_cleaned` AS r
LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.doador_originario_2018_cleaned` AS o
ON r.sequencial_prestador_contas = o.sequencial_prestador_contas 
AND r.sequencial_receita = o.sequencial_receita
)

SELECT *, 
  -- Indicador de tipo de fonte de receita:
  CASE
    WHEN
    nome_doador_rfb_unico NOT LIKE '%PARTIDO%'
      AND nome_doador_rfb_unico NOT LIKE '%BRASIL - BR - NACIONAL%'
      AND nome_doador_rfb_unico NOT LIKE '%ELEICAO 201%'
      AND nome_doador_rfb_unico NOT LIKE '%ELEICOES 2004%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO NACIONAL%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO ESTADUAL%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO REGIONAL%'
      AND nome_doador_rfb_unico NOT LIKE '%REDE SUSTENTABILIDADE%'
      AND nome_doador_rfb_unico NOT LIKE '%MOVIMENTO DEMOCRATICO BRASILEIRO%'
      AND nome_doador_rfb_unico NOT LIKE '%SOLIDARIEDADE%'
      AND nome_doador_rfb_unico NOT LIKE 'PODEMOS'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO D%'
      AND nome_doador_rfb_unico NOT LIKE '%PROGRESSISTAS%'
      AND nome_doador_rfb_unico NOT LIKE '%DEMOCRATAS%'
      AND nome_doador_rfb_unico NOT LIKE '%ESTADUAL'
      AND NOT (nome_doador_rfb_unico LIKE '%PATRIOTA%' AND nome_doador_rfb_unico LIKE '%51%')
      AND nome_doador_rfb_unico NOT LIKE 'PATRIOTA (PATRI)'
      AND nome_doador_rfb_unico NOT LIKE '%DEMOCRACIA CRISTA%'
      AND nome_doador_rfb_unico NOT LIKE '%REGIONAL'
      AND nome_doador_rfb_unico NOT LIKE '%COMISSAO PROVISORIA%'
      AND nome_doador_rfb_unico NOT LIKE '%DIRECAO REGIONAL%'
      AND nome_doador_rfb_unico NOT LIKE 'REPUBLICANOS'
      AND nome_doador_rfb_unico NOT LIKE '%DIRETORIO MUNICIPAL%'
      AND nome_doador_rfb_unico NOT IN (
        'PATRIOTA - PARANAGUA - PR - MUNICIPAL', 
        '19 - PODEMOS BAURU - SP - MUNICIPAL', 
        'DIRETORIO METROPOLITANO - PDT',
        'RIO DE JANEIRO PATRIOTAS',
        'COMISSAO DIRETORA PROVISORIA DO PCB DE MINAS GERAIS',
        'PODEMOS - ORGAO PROVISORIO MUNICIPAL',
        'TRIBUNAL SUPERIOR ELEITORAL'
      ) THEN 'Privada'
    ELSE 'Pública'
  END AS tipo_receita

FROM receitas_completas 