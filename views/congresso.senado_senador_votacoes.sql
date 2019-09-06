/* Cria uma tabela de ID para as votações a partir de 4 colunas ordenadas */
with id_votacao as (
SELECT SessaoPlenaria.DataSessao as data, 
IdentificacaoMateria.NumeroMateria as numMateria, 
DescricaoVotacao as descricaoVotacao, 
DescricaoResultado as resultado, 
row_number() over (order by SessaoPlenaria.DataSessao, IdentificacaoMateria.NumeroMateria, DescricaoVotacao, DescricaoResultado) as num_votacao
FROM `gabinete-compartilhado.senado.senador_votacoes` 
group by IdentificacaoMateria.NumeroMateria, DescricaoVotacao, SessaoPlenaria.DataSessao, DescricaoResultado
)

/* Cria tabela com número da votação acima e id do senador */
-- Dados da votação:
select id_votacao.num_votacao,
v.SessaoPlenaria.DataSessao, v.DescricaoVotacao, v.DescricaoResultado, v.IndicadorVotacaoSecreta as votacaoSecreta,
-- Dados da matéria:
v.IdentificacaoMateria.SiglaSubtipoMateria as tipoMateria, v.IdentificacaoMateria.NumeroMateria, v.IdentificacaoMateria.AnoMateria,
CAST(ARRAY_REVERSE(SPLIT(v.api_url, '/'))[ORDINAL(2)] AS INT64) AS id_senador, 
-- Dados do senador:
s.IdentificacaoParlamentar.NomeParlamentar as nome_senador, p.sigla_nova as partido_senador, 
s.IdentificacaoParlamentar.UfParlamentar as uf_senador, 

-- Votos:
v.DescricaoVoto,
CASE v.DescricaoVoto 
  WHEN 'Sim' THEN 'Sim'
  WHEN 'Não' THEN 'Não'
  WHEN 'Obstrução' THEN 'Obstrução'
  WHEN 'P-OD' THEN 'Obstrução'
  WHEN 'Não - Presidente Art.48 inciso XXIII' THEN 'Não'
  WHEN 'Sim - Presidente Art.48 inciso XXIII' THEN 'Sim'
  WHEN 'Votou' THEN 'Votou'
  WHEN 'Abstenção' THEN 'Abstenção'
  WHEN 'P-NRV' THEN 'Abstenção'
  WHEN NULL THEN NULL
  ELSE 'Outros'
END AS voto_simplificado,
-- Voto BOOL (ERRADO, obstrução não é equivalente a Não!):
  CASE
    WHEN v.DescricaoVoto = 'Obstrução' THEN 0
    WHEN v.DescricaoVoto = 'Não' THEN 0
    WHEN v.DescricaoVoto = 'Sim' THEN 1
  END AS voto_bool

from id_votacao, `gabinete-compartilhado.senado.senador_votacoes` as v left join `gabinete-compartilhado.senado.senadores` as s
on s.IdentificacaoParlamentar.CodigoParlamentar = CAST(ARRAY_REVERSE(SPLIT(v.api_url, '/'))[ORDINAL(2)] AS INT64)
left join `gabinete-compartilhado.congresso.partidos_novas_siglas` as p on p.sigla_antiga = s.IdentificacaoParlamentar.SiglaPartidoParlamentar 
where id_votacao.data = v.SessaoPlenaria.DataSessao
and id_votacao.numMateria = v.IdentificacaoMateria.NumeroMateria 
and id_votacao.descricaoVotacao = v.DescricaoVotacao 
and id_votacao.resultado = v.DescricaoResultado

order by num_votacao