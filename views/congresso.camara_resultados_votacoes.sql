-- Tabela com votações repetidas (capture_dates diferentes) eliminadas: 
WITH v as (
SELECT DISTINCT data, hora, objvotacao, resumo, voto, codsessao, idecadastro, api_url 
FROM `gabinete-compartilhado.camara_v1.proposicao_votacao_deputado`
)


SELECT 
PARSE_DATETIME('%d/%m/%Y %H:%M', CONCAT(v.Data, ' ', v.Hora)) AS timestamp,
countif(TRIM(v.voto) = "Sim") as votos_sim,
countif(TRIM(v.voto) = "Não") as votos_nao,
countif(TRIM(v.voto) = "Abstenção" OR TRIM(v.voto) = "Branco") as votos_abs,
countif(TRIM(v.voto) = "Obstrução") as votos_obs,
countif(TRIM(v.voto) = "-") as ausentes,
countif(TRIM(v.voto) = "Art. 17") as art17,
countif(TRIM(v.voto) = "Sim" OR TRIM(v.voto) = "Não" OR TRIM(v.voto) = "Abstenção" OR TRIM(v.voto) = "Branco") as votos_totais,
v.resumo, v.codSessao, v.objvotacao, v.api_url
FROM v
group by v.resumo, v.codSessao, v.objvotacao, v.Data, v.Hora, v.api_url

