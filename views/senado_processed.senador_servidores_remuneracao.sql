-- Tabela com nomes, cargos e remuneração dos funcionários comissionados dos senadores, no gabinete e no escritório de apoio --
-- Os dados repetem para cada capture_date (que deve ocorrer uma vez por mês).

SELECT
  -- Dados do senador:
  s.IdentificacaoParlamentar.CodigoParlamentar, s.IdentificacaoParlamentar.NomeParlamentar, s.partido_sigla_nova, s.uf_ultimo_mandato, 
  -- Data de referência dos dados do comissionado:
  c.capture_date, 
  -- Dados do comissionado:
  REGEXP_EXTRACT(c.setor_exercicio, r'(GABINETE|ESCRITÓRIO DE APOIO)') AS local_trabalho,
  c.setor_exercicio, c.tipo_vinculo, c.nome_comissionado, c.nome_funcao, c.categoria, c.cargo,
  -- Sigla do cargo e remuneração do cargo (a data de vigência é quando passou a valer o valor em questão).
  r.sigla_cargo, r.valor_total_comissionado, r.data_vigencia 

-- Tabela de comissionados:
FROM `gabinete-compartilhado.senado_processed.pessoas_servidores_cleaned` AS c
-- Tabela de correção de nomes de senadores:
LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.servidores_traducao_nomes_senadores` AS t
ON REGEXP_EXTRACT(c.setor_exercicio, r'SENADORA? +(.*)$') = t.nome_base_servidores
-- Tabela dos senadores:
LEFT JOIN `gabinete-compartilhado.senado_processed.senadores_expandida` AS s
ON t.nome_senador = UPPER(s.IdentificacaoParlamentar.NomeParlamentar)
-- Tabela de remuneração:
LEFT JOIN `gabinete-compartilhado.bruto_gabinete_administrativo.senado_cargo_remuneracao` AS r
ON c.nome_funcao = r.nome_cargo 
-- Restringe a funcionários de senadores:
WHERE UPPER(setor2) LIKE '%GABSEN%'