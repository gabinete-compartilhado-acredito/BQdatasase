-- query que retorna os dados de receita dos senadores da legislação 55 e 56
select 
b.id_parlamentar, 
b.nome_parlamentar, 
b.cpf_candidato_str, 
b.uf, 
b.sigla_partido,
b.legislatura,
cast(substr(a.desc_eleicao, 17,4 ) as int64) as ano_eleicao, -- pegando o ano da eleição a partir da descrição
a.sequencial_candidato,
a.cargo, 
a.nome_doador_unico, 
a.tipo_doador_unico, 
a.valor_receita_unico,
a.descricao_receita_unico,
a.cpfcnpj_doador_unico as cpf_cnpj_doador_unico
from  `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2014` as a
right join `gabinete-compartilhado.senado_processed.senadores_leg56_cpf_tse_view` as b
on a.cpf_candidato = b.cpf_candidato_str 
where b.legislatura = 55

union all 

select 
c.id_parlamentar, 
c.nome_parlamentar, 
c.cpf_candidato_str, 
c.uf, 
c.sigla_partido,
c.legislatura,
d.ano_eleicao,
d.sequencial_candidato,
d.cargo,
d.nome_doador_unico, 
d.tipo_doador_unico, 
d.valor_receita_unico,
d.descricao_receita_unico,
d.cpf_cnpj_doador_unico  
from `gabinete-compartilhado.senado_processed.senadores_leg56_cpf_tse_view` as c 
left join `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018` as d
on d.cpf_candidato_str  = c.cpf_candidato_str
where c.legislatura = 56
