-- Tabela de contabilidade de assinaturas onde criamos uma coluna para o título das assinaturas 
-- e uma coluna para o resultado daquela assinatura.

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "IR, dividendos" AS emenda, emenda_ir AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "Controle de isenções" AS emenda, emenda_transparencia AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "IPVA expandido" AS emenda, emenda_ipva AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "Devolução à baixa renda" AS emenda, emenda_devolucao_baixa_renda AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "Exceção a exportações" AS emenda, emenda_excecao_exportacoes AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "Desoneração da folha" AS emenda, emenda_desoneracao_folha AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "Piso da seguridade" AS emenda, emenda_piso_seguridade AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "ITCMD à União" AS emenda, emenda_itcmd AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
UNION ALL

SELECT 
  gabinete_sala, gabinete_predio, gabinete_andar, ultimoStatus_nome, sigla_partido, uf, 
  "Piso da transferência" AS emenda, emenda_piso_transferencia AS assina
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.contabilidade_assinaturas`
