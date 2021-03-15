SELECT  
any_value(id_parlamentar) as id_parlamentar, 
any_value(nome_parlamentar) as nome_parlamentar , 
any_value(cpf_candidato_str) as cpf_candidato_str , 
any_value(uf) as uf,
any_value(sigla_partido) as sigla_partido ,
any_value(legislatura) as legislatura , 
any_value(a.ano_eleicao) as ano_eleicao , 
sequencial_candidato,  
round(sum(valor_receita_unico),2) as receita_total,
-- Votos:
any_value(b.QT_VOTOS_NOMINAIS) AS votos_obtidos,
-- Custo do voto:
sum(valor_receita_unico) / CAST(any_value(b.QT_VOTOS_NOMINAIS) AS FLOAT64) AS custo_voto

-- tabela de receitas
FROM `gabinete-compartilhado.tratado_tse_processed.senado_receitas_completas_2014_2018` as a

-- tabela de votos
left join `gabinete-compartilhado.tratado_tse.total_votos_por_eleicao_cand` as b
on a.sequencial_candidato = b.SQ_CANDIDATO

group by sequencial_candidato