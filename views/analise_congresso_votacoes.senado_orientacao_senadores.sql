SELECT
/* Colunas de tabelas anteriores */
v.num_votacao, 
o.legislatura, o.ano, 
dt.data_displaced,
v.DataSessao, v.votacaoSecreta, v.DescricaoResultado, v.tipoMateria, v.id_senador, v.nome_senador, v.partido_senador, v.DescricaoVoto, v.voto_bool,
o.id_lider_gov, o.DescricaoVoto as voto_lider_gov, o.voto_bool as voto_bool_lider_gov, 
/* Nova coluna: apoio */
CASE v.voto_bool = o.voto_bool WHEN true THEN 1 ELSE 0 END as apoio
/* Tabelas utilizadas */
FROM `gabinete-compartilhado.congresso.senado_orientacao_governo` as o,
     `gabinete-compartilhado.congresso.senado_senador_votacoes` as v
     left join `gabinete-compartilhado.congresso.support_date_legislaturas` as dt on v.DataSessao = dt.aday 
WHERE o.num_votacao = v.num_votacao
/* Vamos excluir votos que não são sim, não, obstrução (voto_bool=null) */
and o.voto_bool is not null
and v.voto_bool is not null