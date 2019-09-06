SELECT 
PARSE_DATETIME('%Y-%m-%d %H:%M', CONCAT(DataSessao, ' ' , HoraInicio)) as timestamp,
CodigoSessaoVotacao as cod_sessao,
DescricaoVotacao as obj_votacao,
DescricaoIdentificacaoMateria as resumo,
NomeParlamentar as nome,
CodigoParlamentar as id_senador,
t2.sigla_nova  as sigla_partido,
SiglaUF  as uf,
Voto as voto,
NumeroMateria as numero,
AnoMateria as ano,
CodigoMateria as id_proposicao
FROM `gabinete-compartilhado.senado.votacoes_plenario` t1
JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` t2
ON t1.SiglaPartido  = t2.sigla_antiga 
WHERE Secreta = 'N'