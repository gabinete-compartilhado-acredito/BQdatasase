/***
    Tabela de políticos com mandato (de acordo com eleições) em 2019 e 2021
    
    Selecionamos os candidatos que foram eleitos em eleições tais que seus 
    mandatos deveriam estar vigentes nos anos de 2019 ou 2021. Na verdade,
    a única diferença entre esses dois anos se dá no nível municipal
    (vereadores e prefeitos foram trocados no final de 2020).
    
    Caso o candidato tenha sido eleito em mais de uma eleição, o resultado 
    que aparece é para o ano mais recente.
 ***/
 
SELECT 
  ARRAY_AGG(nome_candidato ORDER BY ano_eleicao)[OFFSET(0)] AS nome_candidato, 
  cpf_candidato_str,
  ARRAY_AGG(ano_eleicao ORDER BY ano_eleicao)[OFFSET(0)] AS ano_eleicao, 
  ARRAY_AGG(sigla_partido_original ORDER BY ano_eleicao)[OFFSET(0)] AS sigla_partido_original, 
  ARRAY_AGG(sg_uf  ORDER BY ano_eleicao)[OFFSET(0)] AS uf, 
  ARRAY_AGG(ds_cargo  ORDER BY ano_eleicao)[OFFSET(0)] AS cargo

FROM `gabinete-compartilhado.tratado_tse_processed.consulta_candidatos_cleaned`
WHERE part_ano >= 2014
    -- Seleção de políticos atualmente eleitos:
  AND (
    -- Mandato de 8 anos:
    (
     ano_eleicao IN (2014, 2018) AND 
     ds_cargo IN ('SENADOR', '1º SUPLENTE', '2º SUPLENTE') AND 
     situacao_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
    ) OR
    -- Mandato de 4 anos:
    (
     ano_eleicao IN (2016, 2018, 2020) AND 
     ds_cargo IN ('VEREADOR', 'DEPUTADO FEDERAL', 'DEPUTADO DISTRITAL', 'DEPUTADO ESTADUAL', 'PREFEITO', 'VICE-PREFEITO', 'GOVERNADOR', 'VICE-GOVERNADOR', 'PRESIDENTE', 'VICE-PRESIDENTE') AND 
     situacao_tot_turno IN ('ELEITO', 'ELEITO POR QP', 'ELEITO POR MÉDIA')
    )
  )
GROUP BY cpf_candidato_str