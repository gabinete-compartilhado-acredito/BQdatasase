/***
    Tabela de contabilidade de ações parlamentares de cada tipo.
    Para cada parlamentar, retorna o número de ações, a posição no raking e a porcentagem de senadores com contagem igual ou inferior.
 ***/

-- Tabela que contabiliza o número de ações dos parlamentares:
WITH agg AS (
  SELECT nome_autor, sigla_partido_autor, sigla_uf_autor,
  --COUNTIF(tipo_atividade = 'Aprovações de requerimentos') AS aprov_req,
  --COUNTIF(tipo_atividade = 'Discussões de matéria') AS discussao_materia,
  --COUNTIF(tipo_atividade = 'Obstruções da discussão (Plenário)') AS obstrucao,
  --COUNTIF(tipo_atividade = 'Outros') AS outros,
  COUNTIF(tipo_atividade = 'Pedidos de audiência pública') AS aud_publica,
  COUNTIF(tipo_atividade = 'Pedidos de desarquivamento') AS desarquivamento,
  COUNTIF(tipo_atividade = 'Pedidos de informação') AS informacao,
  COUNTIF(tipo_atividade = 'Relatorias assumidas') AS relat_assumidas,
  COUNTIF(tipo_atividade = 'Relatorias entregues') AS relat_entregues,
  COUNTIF(tipo_atividade = 'Propostas apresentadas') AS apresenta_pro
  FROM `gabinete-compartilhado.datastudio.atividade_senado_`
  GROUP BY nome_autor, sigla_partido_autor, sigla_uf_autor
)

-- Tabela principal -- Para cada parlamentar, retorna o número de ações, a posição no raking e o percentil ocupado para cada tipo de ação:
SELECT

ROW_NUMBER() OVER (ORDER BY dep.nome_autor) AS alpha_order,
-- Info do parlamentar:
dep.nome_autor, dep.sigla_partido_autor, dep.sigla_uf_autor, 

-- Aud. Pública (# absoluto; posição do ranking; percentil do senador):
dep.aud_publica, 
COUNTIF(todos.aud_publica > dep.aud_publica) + 1 AS pos_aud_publica,
(COUNTIF(todos.aud_publica <= dep.aud_publica)) / COUNT(todos.aud_publica) * 100 AS pc_aud_publica,

-- Desarquivamento (# absoluto; posição do ranking; percentil do senador):
dep.desarquivamento, 
COUNTIF(todos.desarquivamento > dep.desarquivamento) + 1 AS pos_desarquivamento,
(COUNTIF(todos.desarquivamento <= dep.desarquivamento)) / COUNT(todos.desarquivamento) * 100 AS pc_desarquivamento,

-- Pedidos de informacao (# absoluto; posição do ranking; percentil do senador):
dep.informacao, 
COUNTIF(todos.informacao > dep.informacao) + 1 AS pos_informacao,
(COUNTIF(todos.informacao <= dep.informacao)) / COUNT(todos.informacao) * 100 AS pc_informacao,

-- Relatorias assumidas (# absoluto; posição do ranking; percentil do senador):
dep.relat_assumidas, 
COUNTIF(todos.relat_assumidas > dep.relat_assumidas) + 1 AS pos_relat_assumidas,
(COUNTIF(todos.relat_assumidas <= dep.relat_assumidas)) / COUNT(todos.relat_assumidas) * 100 AS pc_relat_assumidas,

-- Relatorias entregues (# absoluto; posição do ranking; percentil do senador):
dep.relat_entregues, 
COUNTIF(todos.relat_entregues > dep.relat_entregues) + 1 AS pos_relat_entregues,
(COUNTIF(todos.relat_entregues <= dep.relat_entregues)) / COUNT(todos.relat_entregues) * 100 AS pc_relat_entregues,

-- Apresentação de proposições (# absoluto; posição do ranking; percentil do senador):
dep.apresenta_pro, 
COUNTIF(todos.apresenta_pro > dep.apresenta_pro) + 1 AS pos_apresenta_pro,
(COUNTIF(todos.apresenta_pro <= dep.apresenta_pro)) / COUNT(todos.apresenta_pro) * 100 AS pc_apresenta_pro,

-- Foto do parlamentar:
ANY_VALUE(sen.IdentificacaoParlamentar.UrlFotoParlamentar) AS url_foto_autor

FROM agg AS dep
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS sen
ON dep.nome_autor = sen.IdentificacaoParlamentar.NomeParlamentar

CROSS JOIN agg AS todos
GROUP BY 
  dep.nome_autor, dep.sigla_partido_autor, dep.sigla_uf_autor, 
  dep.aud_publica, dep.desarquivamento, dep.informacao, dep.relat_assumidas, dep.relat_entregues, dep.apresenta_pro 

ORDER BY nome_autor
