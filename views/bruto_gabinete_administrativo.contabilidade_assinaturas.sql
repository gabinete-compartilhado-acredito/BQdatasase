WITH agg AS (
  -- Junta registros manuais e via formulário:
  WITH assinaturas AS (
    SELECT * FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas_formulario`
    UNION ALL
    SELECT * FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas_manual`
  )
  -- Agrupa os registros por gabinete:
  SELECT gabinete, 
    STRING_AGG(DISTINCT emenda_ir, " | " ORDER BY emenda_ir) AS emenda_ir,
    STRING_AGG(DISTINCT emenda_devolucao_baixa_renda, " | " ORDER BY emenda_devolucao_baixa_renda) AS emenda_devolucao_baixa_renda,
    STRING_AGG(DISTINCT emenda_itcmd, " | " ORDER BY emenda_itcmd) AS emenda_itcmd,
    STRING_AGG(DISTINCT emenda_ipva, " | " ORDER BY emenda_ipva) AS emenda_ipva,
    STRING_AGG(DISTINCT emenda_piso_transferencia, " | " ORDER BY emenda_piso_transferencia) AS emenda_piso_transferencia,
    STRING_AGG(DISTINCT emenda_desoneracao_folha, " | " ORDER BY emenda_desoneracao_folha) AS emenda_desoneracao_folha,
    STRING_AGG(DISTINCT emenda_excecao_exportacoes, " | " ORDER BY emenda_excecao_exportacoes) AS emenda_excecao_exportacoes,
    STRING_AGG(DISTINCT emenda_piso_seguridade, " | " ORDER BY emenda_piso_seguridade) AS emenda_piso_seguridade,
    STRING_AGG(DISTINCT emenda_transparencia, " | " ORDER BY emenda_transparencia) AS emenda_transparencia
  FROM assinaturas 
  GROUP BY gabinete
)

-- Seleciona a lista dos gabinetes e junta a eles o registro de assinaturas:
-- (elimina assinaturas de gabinetes não existentes)
SELECT 
  d.gabinete_sala, d.gabinete_predio, d.gabinete_andar, d.ultimoStatus_nome, d.sigla_partido, d.uf,
  agg.*,
  IF(agg.gabinete IS NULL, "Nenhum registro", "Algum registro") AS registro
FROM `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS d
LEFT JOIN agg 
ON d.gabinete_sala = CAST(agg.gabinete AS INT64)
WHERE d.ultima_legislatura = 56 AND d.ultimoStatus_situacao = 'Exercício'
ORDER BY gabinete_sala, ultimoStatus_nome, sigla_partido, uf