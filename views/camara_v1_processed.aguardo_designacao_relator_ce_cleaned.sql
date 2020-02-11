/***
     Limpa a tabela de proposições aguardando designação de relator na CE:
     - Separa nome da proposição em tipo, número e ano;
     - Retira quebras de linha da descrição (desligado).
 ***/
 
SELECT
proposicao,
SPLIT(TRIM(proposicao), ' ')[OFFSET(0)] AS sigla_tipo,
CAST(SPLIT(SPLIT(TRIM(proposicao), ' ')[OFFSET(1)], '/')[OFFSET(0)] AS INT64) AS numero,
CAST(SPLIT(SPLIT(TRIM(proposicao), ' ')[OFFSET(1)], '/')[OFFSET(1)] AS INT64) AS ano,
descricao
--REPLACE(descricao, '\n', ' ') AS descricao

FROM `gabinete-compartilhado.camara_v1.aguardo_designacao_relator_ce`