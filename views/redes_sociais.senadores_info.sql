SELECT IdentificacaoParlamentar.CodigoParlamentar as id, 
IdentificacaoParlamentar.NomeParlamentar as ultimoStatus_nome,
IdentificacaoParlamentar.SiglaPartidoParlamentar as sigla_partido, 
IdentificacaoParlamentar.UfParlamentar as uf
FROM `gabinete-compartilhado.senado_processed.senadores_expandida`
where legislatura = 56 
