SELECT 
IdentificacaoMateria.AnoMateria as ano,
IdentificacaoMateria.CodigoMateria as numero,
IdentificacaoMateria.SiglaSubtipoMateria as sigla_tipo,
Assunto.AssuntoEspecifico.Descricao as tema,
Assunto.AssuntoGeral.Descricao as macro_tema,
DadosBasicosMateria.DataApresentacao as data_apresentacao,
CasaIniciadoraNoLegislativo.NomeCasaIniciadora as casa_iniciadora,
capture_date,
api_url
FROM `gabinete-compartilhado.senado.proposicoes` 
