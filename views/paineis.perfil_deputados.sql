/***
    Esta tabela consolida todas as informações (traça um perfil) dos deputados, em formato de apresentação:
    - Temas de interesse;
    - Bancadas (segundo levantamento da Pública 2016);
    - Alinhamento com próprio partido;
    - Alinhamento com governo;
    - Alinhamento com Tabata;
    - Alinhamento com Rigoni.
 ***/

WITH 
-- Tabela que consolida os 5 temas de maior interesse do deputado numa string:
tab_temas AS (
  SELECT 
    id_deputado, ultimoStatus_nome, sigla_partido, uf, 
    STRING_AGG(CONCAT(tema , " (", CAST(ROUND(n_intervencoes/n_total*100, 1) AS STRING), "%)"), '\n' ORDER BY n_intervencoes DESC LIMIT 5) AS temas,
    ARRAY_AGG(STRUCT(tema, n_intervencoes/n_total AS frequencia, SQRT(n_intervencoes)/n_total AS frequencia_erro) ORDER BY n_intervencoes DESC) AS interesse
  FROM `gabinete-compartilhado.analise_congresso_atividade.deputados_temas_interesse_consolidado`
  GROUP BY id_deputado, ultimoStatus_nome, sigla_partido, uf
),

-- Tabela com todas as lideranças mais recentes dos deputados agregadas em arrays:
lider AS (
  -- Numera as datas de registro de lideranças para podermos selecionar a última:
  WITH numbered_data_lider AS (
    SELECT DENSE_RANK() OVER (ORDER BY data DESC) AS desc_data_pos, * 
    FROM `gabinete-compartilhado.camara_v1_processed.liderancas_stacked`
  )
  SELECT id_deputado, ARRAY_AGG(STRUCT(cargo, sigla_bloco)) AS liderancas
  FROM numbered_data_lider
  WHERE desc_data_pos = 1
  GROUP BY id_deputado
),

-- Tabela com presidências e vices de comissões, mais membros da mesa diretora, agregados em arrays por deputado:
cargos AS (
  SELECT id_deputado, ARRAY_AGG(STRUCT(sigla_orgao, titulo, nome_orgao) ORDER BY codigo_titulo) AS orgaos
  FROM `gabinete-compartilhado.camara_v2_processed.deputados_orgaos_cleaned`
  WHERE 
    -- Seleciona apenas cargos em vigor na atualidade:
    CURRENT_DATETIME("-03") > data_inicio AND (data_fim IS NULL OR current_datetime("-03") < data_fim) 
    -- Presidentes e vices de comissões:
    AND (((titulo = 'Presidente' OR titulo LIKE '%Vice-Presidente') AND LOWER(nome_orgao) LIKE '%comissão%')
    -- Membros da mesa diretora:
    OR (sigla_orgao = 'MESA' AND titulo != 'Titular' AND titulo != 'Suplente'))
  GROUP BY id_deputado
)

SELECT
  -- Info do deputado:
  t.id_deputado, t.ultimoStatus_nome, t.sigla_partido, t.uf,
  -- Temas de interesse:
  t.interesse, 
  -- Bancadas (Pública 2016):
  b.array_bancadas,
  -- Lideranças de blocos e partidos:
  lider.liderancas,
  -- Presidência e vice de comissões e membro da mesa diretora:
  cargos.orgaos,
  -- Alinhamento com próprio partido e governo:
  g.alinhamento_partido, g.alinhamento_gov,
  -- Alinhamento com parlamentares do Acredito:
  tabata.alinhamento AS alinhamento_tabata, rigoni.alinhamento AS alinhamento_rigoni
  
FROM tab_temas AS t 
LEFT JOIN `gabinete-compartilhado.analise_congresso_poder.camara_bancadas_publica_consolidado` AS b  ON t.id_deputado = b.id 
LEFT JOIN `gabinete-compartilhado.analise_congresso_votacoes.alinhamento_tabata_deputados` AS tabata ON t.id_deputado = tabata.id_deputado_2 
LEFT JOIN `gabinete-compartilhado.analise_congresso_votacoes.alinhamento_rigoni_deputados` AS rigoni ON t.id_deputado = rigoni.id_deputado_2 
LEFT JOIN `gabinete-compartilhado.paineis.apoio_deputados_governo_consolidado`  AS g ON t.id_deputado = g.id_deputado
LEFT JOIN lider ON t.id_deputado = lider.id_deputado
LEFT JOIN cargos ON t.id_deputado = cargos.id_deputado