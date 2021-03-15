/*** 
    Tabela de total de receitas obtidas pelos candidatos nas eleições de 2018.
    Aqui nós agrupamos as receitas por ano e por candidato (sequencial_candidato)
    e somamos todos os valores declarados de doações.
    
    Também calculamos o total de receitas privadas, isto é: que não vêm dos
    partidos e nem do TSE.
 ***/

SELECT 
  ano_eleicao,
  ANY_VALUE(cargo) AS cargo, sequencial_candidato, 
  ANY_VALUE(nome_candidato) AS nome_candidato, ANY_VALUE(cpf_candidato_str) AS cpf_candidato, ANY_VALUE(sigla_partido_candidato) AS sigla_partido_candidato,
  ANY_VALUE(sigla_unidade_eleitoral_candidato) AS uf_candidato, 
  -- Valor total das receitas de campanha:
  SUM(valor_receita_unico) AS receita_total,
  -- Valor total das receitas privadas:
  SUM(IF(tipo_receita = 'Privada', valor_receita_unico, 0)) AS receita_privada,
  COUNT(DISTINCT IF(tipo_receita = 'Privada', nome_doador_rfb_unico, NULL)) AS n_doadores_privados

FROM `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018`
GROUP BY ano_eleicao, sequencial_candidato





