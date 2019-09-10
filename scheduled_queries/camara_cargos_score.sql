# destination_table: analise_congresso_poder.camara_cargos_score

SELECT t1.*, t2.score
FROM (
SELECT *
FROM (
SELECT 
data_inicio ,
data_fim ,
id_deputado ,
CASE
WHEN tipo = 'Classe A' AND titulo = 'Presidente' THEN 'Presidencia Comissao Serie A  - CCJC, CMO e CFT'
WHEN tipo = 'Classe B' AND titulo = 'Presidente' THEN 'Presidencia Comissao Serie B - CE, CETASP, CINDA, CREDEN, CSSF, CCTCI, CVT, CMADS, CSPCCO, CME, CAPADR, CDC, CDEIC'
WHEN tipo = 'Classe C' AND titulo = 'Presidente' THEN 'Presidencia de Comissao Serie C - Resto'
WHEN (tipo = 'Classe A' OR tipo = 'Comissão Mista de Orcamento')
     AND titulo = 'Titular' THEN 'Membro de Comissao Serie A - CCJC, CMO e CFT'
WHEN tipo = 'Classe B' AND titulo = 'Titular' THEN 'Membro de Comissao Serie B - CE, CETASP, CINDA, CREDEN, CSSF, CCTCI, CVT, CMADS, CSPCCO, CME, CAPADR, CDC, CDEIC'
WHEN tipo = 'Classe C' AND titulo = 'Titular' THEN 'Membro de Comissao Serie C - Resto'
WHEN tipo = 'CPI' AND titulo = 'Presidente' THEN 'Presidente CPI'
WHEN tipo = 'CPI' AND (titulo = 'Relator' AND titulo = '1º Vice-Presidente' 
                  AND titulo = 'Titular' AND titulo = '2º Vice-Presidente'
                  AND titulo = '3º Vice-Presidente') THEN 'Membro CPI'
WHEN tipo LIKE 'Comissao Especial%' AND titulo = 'Relator' THEN 'Relator de Comissao Especial'
END as cargo
FROM `gabinete-compartilhado.congresso.camara_deputados_orgaos`)
WHERE cargo is not null
UNION ALL
SELECT *, 'Membro da Mesa'
FROM `gabinete-compartilhado.congresso.camara_deputados_mesa` ) t1
JOIN `gabinete-compartilhado.analise_congresso_poder.cargo_score` t2
ON t1.cargo = t2.cargo 