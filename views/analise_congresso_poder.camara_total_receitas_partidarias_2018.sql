/***
    Tabela de valores obtidos por deputados federais da legislatura 56 de partidos em 2018
    
    - A coluna 'valor_candidato' contém todos os valores obtidos de partidos políticos 
      (mesmo que não seja do partido do candidato, embora isso seja raro), e de qualquer 
      nível federativo (nacional, estadual, regional, distrital, municipal).
    - A tabela contabiliza o total de verbas eleitorais obtidas pelos candidatos 
      de um dado partido e estado. Essa verba está na coluna 'valor_partidario_estadual'.
    - A coluna 'frac_partidario_estadual' informa o quanto que cada candidato pegou do 
      total de verbas alocadas no seu partido de eleição (que pode não ser o atual), no 
      seu estado.
 ***/
 
SELECT
  p.id AS id_parlamentar,
  p.ultimoStatus_nome AS nome_parlamentar, 
  p.sigla_partido, 
  p.uf, 
  p.nome_civil, 
  p.cpf, 
  r.valor_candidato AS valor_candidato, 
  r.valor_partidario_estadual, 
  r.frac_partidario_estadual
FROM 
  `gabinete-compartilhado.camara_v2_processed.deputados_detalhes_cleaned` AS p
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.receitas_partidarias_cand_dep_federal_2018` AS r
  ON p.cpf = CAST(r.cpf_candidato_str AS INT64)
WHERE p.ultima_legislatura = 56