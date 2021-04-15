/***
    Tabela de valores obtidos por senadores da legislatura 56 de partidos em 2014 e 2018
    (de acordo com a eleição na qual foi eleito).
    
    - A coluna 'valor_candidato' contém todos os valores obtidos de partidos políticos 
      (mesmo que não seja do partido do candidato, embora isso seja raro), e de qualquer 
      nível federativo (nacional, estadual, regional, distrital, municipal).
    - A tabela contabiliza o total de verbas eleitorais obtidas pelos candidatos 
      de um dado partido e estado. Essa verba está na coluna 'valor_partidario_estadual'.
    - A coluna 'frac_partidario_estadual' informa o quanto que cada candidato pegou do 
      total de verbas alocadas no seu partido de eleição (que pode não ser o atual), no 
      seu estado.
 ***/
 
-- Senadores eleitos em 2018:
SELECT
  p.id_parlamentar,
  p.nome_parlamentar, 
  p.sigla_partido, 
  p.uf,
  p.ds_cargo,
  p.nome_completo_parlamentar, 
  p.cpf_candidato_str, 
  r.valor_candidato AS valor_candidato, 
  r.valor_partidario_estadual, 
  r.frac_partidario_estadual
FROM 
  `gabinete-compartilhado.senado_processed.senadores_leg56_cpf_tse` AS p
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.receitas_partidarias_cand_senador_2018` AS r
  ON p.cpf_candidato_str = r.cpf_candidato_str
WHERE p.legislatura = 56

UNION ALL

-- Senadores eleitos em 2014:
SELECT
  p.id_parlamentar,
  p.nome_parlamentar, 
  p.sigla_partido, 
  p.uf,
  p.ds_cargo,
  p.nome_completo_parlamentar, 
  p.cpf_candidato_str, 
  r.valor_candidato AS valor_candidato, 
  r.valor_partidario_estadual, 
  r.frac_partidario_estadual
FROM 
  `gabinete-compartilhado.senado_processed.senadores_leg56_cpf_tse` AS p
  LEFT JOIN `gabinete-compartilhado.tratado_tse_processed.receitas_partidarias_cand_senador_2014` AS r
  ON p.cpf_candidato_str = r.cpf_candidato_str
WHERE p.legislatura = 55
