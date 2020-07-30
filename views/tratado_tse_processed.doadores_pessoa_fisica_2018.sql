WITH doadores AS (
SELECT nome_doador_rfb_unico, cpf_cnpj_doador_unico, ANY_VALUE(nome_doador_unico) AS nome_doador_unico, 
COUNT(distinct nome_candidato) AS n_cand, SUM(valor_receita_unico) AS valor_total

FROM `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018`

WHERE nome_doador_rfb_unico NOT LIKE '%PARTIDO%'
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

GROUP BY nome_doador_rfb_unico, cpf_cnpj_doador_unico
ORDER BY valor_total DESC
)

SELECT *, 
SUM(valor_total) OVER () AS valor_total_eleicoes, 
SUM(valor_total) OVER (ORDER BY valor_total DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS valor_cumulativo,
SUM(valor_total) OVER (ORDER BY valor_total DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(valor_total) OVER () AS fracao_cumulativa,
valor_total / SUM(valor_total) OVER () AS fracao_do_total
FROM doadores