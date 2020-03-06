SELECT Codigo_Materia,
ane.IdentificacaoMateria.CodigoMateria as materia_anexada,
ane.IdentificacaoMateria.DescricaoSubtipoMateria as Descricao_Subtipo_Materia_anexada,
ane.IdentificacaoMateria.SiglaSubtipoMateria as Sigla_Subtipo_Materia_anexada,
ane.IdentificacaoMateria.NumeroMateria as Numero_materia_anexada,
ane.IdentificacaoMateria.AnoMateria as Ano_materia_anexada,
Ane.IdentificacaoMateria.IndicadorTramitando as IndicadorTramitando_materia_anexada , 
Ane.IdentificacaoMateria.NomeCasaIdentificacaoMateria as NomeCasaIdentificacaoMateria_materia_anexada , 
Ane.IdentificacaoMateria.SiglaCasaIdentificacaoMateria as SiglaCasaIdentificacaoMateria_materia_anexada,
ane.DataAnexacao as Data_Anexacao_materia_anexada ,
ane.DataDesanexacao as Data_Desanexacao_materia_anexada, 



FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` as p, 

unnest(p.Materia_Anexada) as ane


  
