/***
    Tabela de contabilidade de ações parlamentares de cada tipo.
    Para cada parlamentar, retorna o número de ações, a posição no raking e a porcentagem de deputados com contagem igual ou inferior.
 ***/

-- Tabela que contabiliza o número de ações dos parlamentares:
WITH agg AS (
  SELECT nome_parlamentar, sigla_partido, sigla_uf,
  COUNTIF(tipo_atividade = 'Requerimentos aprovados') AS aprov_req,
  COUNTIF(tipo_atividade = 'Discussões de matéria') AS discussao_materia,
  COUNTIF(tipo_atividade = 'Obstruções da discussão (Plenário)') AS obstrucao,
  COUNTIF(tipo_atividade = 'Outros') AS outros,
  COUNTIF(tipo_atividade = 'Pedidos de audiência pública') AS aud_publica,
  COUNTIF(tipo_atividade = 'Pedidos de desarquivamento') AS desarquivamento,
  COUNTIF(tipo_atividade = 'Pedidos de informação') AS informacao,
  COUNTIF(tipo_atividade = 'Relatorias assumidas') AS relat_assumidas,
  COUNTIF(tipo_atividade = 'Relatorias entregues') AS relat_entregues,
  COUNTIF(tipo_atividade = 'Propostas apresentadas') AS apresenta_pro
  FROM `gabinete-compartilhado.datastudio.atividade_camara`
  GROUP BY nome_parlamentar, sigla_partido, sigla_uf
)

-- Tabela principal -- Para cada parlamentar, retorna o número de ações, a posição no raking e o percentil ocupado para cada tipo de ação:
SELECT

ROW_NUMBER() OVER (ORDER BY dep.nome_parlamentar) AS alpha_order,
-- Info do parlamentar:
sen.id, dep.nome_parlamentar, dep.sigla_partido, dep.sigla_uf, 

-- Aprov. de requerimento (# absoluto; posição do ranking; percentil do deputado):
dep.aprov_req, 
COUNTIF(todos.aprov_req > dep.aprov_req) + 1 AS pos_aprov_req,
(COUNTIF(todos.aprov_req <= dep.aprov_req)) / COUNT(todos.aprov_req) * 100 AS pc_aprov_req,

-- Discussões de matéria (# absoluto; posição do ranking; percentil do deputado):
dep.discussao_materia, 
COUNTIF(todos.discussao_materia > dep.discussao_materia) + 1 AS pos_discussao_materia,
(COUNTIF(todos.discussao_materia <= dep.discussao_materia)) / COUNT(todos.discussao_materia) * 100 AS pc_discussao_materia,

-- Obstruções de discussão (# absoluto; posição do ranking; percentil do deputado):
dep.obstrucao, 
COUNTIF(todos.obstrucao > dep.obstrucao) + 1 AS pos_obstrucao,
(COUNTIF(todos.obstrucao <= dep.obstrucao)) / COUNT(todos.obstrucao) * 100 AS pc_obstrucao,

-- Aud. Pública (# absoluto; posição do ranking; percentil do deputado):
dep.aud_publica, 
COUNTIF(todos.aud_publica > dep.aud_publica) + 1 AS pos_aud_publica,
(COUNTIF(todos.aud_publica <= dep.aud_publica)) / COUNT(todos.aud_publica) * 100 AS pc_aud_publica,

-- Desarquivamento (# absoluto; posição do ranking; percentil do deputado):
dep.desarquivamento, 
COUNTIF(todos.desarquivamento > dep.desarquivamento) + 1 AS pos_desarquivamento,
(COUNTIF(todos.desarquivamento <= dep.desarquivamento)) / COUNT(todos.desarquivamento) * 100 AS pc_desarquivamento,

-- Pedidos de informacao (# absoluto; posição do ranking; percentil do deputado):
dep.informacao, 
COUNTIF(todos.informacao > dep.informacao) + 1 AS pos_informacao,
(COUNTIF(todos.informacao <= dep.informacao)) / COUNT(todos.informacao) * 100 AS pc_informacao,

-- Relatorias assumidas (# absoluto; posição do ranking; percentil do deputado):
dep.relat_assumidas, 
COUNTIF(todos.relat_assumidas > dep.relat_assumidas) + 1 AS pos_relat_assumidas,
(COUNTIF(todos.relat_assumidas <= dep.relat_assumidas)) / COUNT(todos.relat_assumidas) * 100 AS pc_relat_assumidas,

-- Relatorias entregues (# absoluto; posição do ranking; percentil do deputado):
dep.relat_entregues, 
COUNTIF(todos.relat_entregues > dep.relat_entregues) + 1 AS pos_relat_entregues,
(COUNTIF(todos.relat_entregues <= dep.relat_entregues)) / COUNT(todos.relat_entregues) * 100 AS pc_relat_entregues,

-- Apresentação de proposições (# absoluto; posição do ranking; percentil do deputado):
dep.apresenta_pro, 
COUNTIF(todos.apresenta_pro > dep.apresenta_pro) + 1 AS pos_apresenta_pro,
(COUNTIF(todos.apresenta_pro <= dep.apresenta_pro)) / COUNT(todos.apresenta_pro) * 100 AS pc_apresenta_pro,

-- Outros (# absoluto; posição do ranking; percentil do deputado):
dep.outros, 
COUNTIF(todos.outros > dep.outros) + 1 AS pos_outros,
(COUNTIF(todos.outros <= dep.outros)) / COUNT(todos.outros) * 100 AS pc_outros,

-- Foto do parlamentar:
ANY_VALUE(sen.url_foto) AS url_foto_autor

FROM agg AS dep
LEFT JOIN `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS sen
ON dep.nome_parlamentar = sen.ultimoStatus_nome

CROSS JOIN agg AS todos
GROUP BY 
  sen.id, dep.nome_parlamentar, dep.sigla_partido, dep.sigla_uf,
  dep.aprov_req, dep.discussao_materia, dep.obstrucao, dep.outros,
  dep.aud_publica, dep.desarquivamento, dep.informacao, dep.relat_assumidas, dep.relat_entregues, dep.apresenta_pro 

ORDER BY nome_parlamentar