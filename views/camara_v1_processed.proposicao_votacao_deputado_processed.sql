-- Tabela de última data de captura:
WITH l AS (
  -- Campos originais da proposicao_votacao_deputado que identificam uma votação e um deputado univocamente:
  -- (Algumas votações incluem senadores, e esses não têm id_deputado, mas têm nome)
  SELECT r.Data, r.Hora, r.cod_sessao, r.obj_votacao, r.id_deputado, r.nome, r.api_url,
    -- Data da última captura:
    MAX(r.capture_date) AS capture_date
  FROM `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_deputado_cleaned` as r
  GROUP BY r.Data, r.Hora, r.cod_sessao, r.obj_votacao, r.id_deputado, r.nome, r.api_url
)

-- Seleciona votos únicos, eliminando repetições com mesma data de captura:
SELECT DISTINCT v.*,
-- Nova coluna de votos padronizados:
CASE v.voto
WHEN 'Branco' THEN 'Abstenção'
WHEN '-' THEN 'Ausente'
ELSE v.voto
END AS voto_padronizado,
-- Info das proposições:
p.id AS id_proposicao, p.ementa, p.id_deputado AS id_autor, p.nome_autor, p.sigla_partido_autor, p.sigla_uf_autor AS uf_autor,
p.url_inteiro_teor

FROM `gabinete-compartilhado.camara_v1_processed.proposicao_votacao_deputado_cleaned` AS v
-- Seleciona apenas a última captura:
INNER JOIN l
ON l.Data = v.Data AND l.Hora = v.Hora AND l.cod_sessao = v.cod_sessao AND l.obj_votacao = v.obj_votacao 
  AND l.id_deputado = v.id_deputado AND l.api_url = v.api_url AND l.capture_date = v.capture_date

-- Junta com tabela sobre as proposições:
LEFT JOIN `gabinete-compartilhado.congresso.proposicoes_completa` AS p
ON v.sigla_tipo = p.sigla_tipo AND v.ano = p.ano AND v.numero = p.numero
