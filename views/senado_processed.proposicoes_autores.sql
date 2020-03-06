SELECT Codigo_Materia,
Pa.NomeAutor as Nome_Autor,
Pa.NumOrdemAutor as Num_Order_Autor,
Pa.SiglaTipoAutor as Sigla_Tipo_Autor,
pa.IdentificacaoParlamentar.CodigoParlamentar as Codigo_Parlamentar, 
Pa.IdentificacaoParlamentar.NomeParlamentar as Nome_Parlamentar, 
Pa.IdentificacaoParlamentar.NomeCompletoParlamentar as Nome_Completo, 
Pa.IdentificacaoParlamentar.SiglaPartidoParlamentar as Sigla_Partido, 
Pa.UfAutor as Uf_Autor, 
Pa.IdentificacaoParlamentar.SexoParlamentar as Sexo, 
Pa.IdentificacaoParlamentar.FormaTratamento as Forma_Tratamento , 
Pa.IdentificacaoParlamentar.EmailParlamentar as Email, 
Pa.IdentificacaoParlamentar.UrlFotoParlamentar as Url_Foto, 
Pa.IdentificacaoParlamentar.UrlPaginaParlamentar as Url_Site, 
FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` as p, unnest(p.autoria) as pa



