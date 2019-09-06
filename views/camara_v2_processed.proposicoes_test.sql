/* 
-- Testa o número de vezes que uma certa proposição foi capturada:
SELECT idProposicao, count(distinct capture_date) as n_captures
FROM `gabinete-compartilhado.camara_v2_processed.proposicoes_autores_cleaned`  
group by idProposicao 
order by n_captures desc
*/

/*
-- Testa se essas colunas só possuem valores nulos:
SELECT distinct 
idDeputadoAutor, nomeAutor, codTipoAutor, idProposicao, siglaPartidoAutor, siglaUFAutor, tipoAutor, uriAutor, uriPartidoAutor, uriAutores,
uriProposicao
FROM `gabinete-compartilhado.camara_v2.proposicoes`
*/


-- Testa se essas colunas são todas vazias:
select distinct statusProposicao.*
from `gabinete-compartilhado.camara_v2.proposicoes`
