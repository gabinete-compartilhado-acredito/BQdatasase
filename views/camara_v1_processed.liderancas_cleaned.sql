/***
     Nós renomeamos e reordenamos as colunas da tabela bruta de lideranças e tiramos
     os dados dos líderes e dos representantes do struct (os vice-líderes foram mantidos
     em arrays). Também parseamos a capture_date e a data a qual os dados se referem 
     (extraindo do URL da API). 
 ***/

SELECT
  -- Info dos dados:
  PARSE_DATE('%d/%m/%Y', SPLIT(api_url, '?')[OFFSET(1)]) AS data,
  -- Info do bloco:
  sigla AS sigla_bloco,
  nome AS nome_bloco,
  -- Info do líder:
  lider.ideCadastro AS id_lider,
  lider.nome AS nome_lider,
  lider.partido AS sigla_partido_original_lider,
  lider.uf AS uf_lider,
  -- Info do representante (para partidos pequenos, acho que com 1 deputado):
  representante.ideCadastro AS id_representante,
  representante.nome AS nome_representante,
  representante.partido AS sigla_partido_original_representante,
  representante.uf AS uf_representante,
  -- Array dos vice-líderes:
  vicelider AS array_vicelider,
  -- Info da captura:
  api_url,
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date
FROM `gabinete-compartilhado.camara_v1.liderancas`