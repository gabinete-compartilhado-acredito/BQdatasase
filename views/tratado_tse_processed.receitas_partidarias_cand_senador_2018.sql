/***
    Tabela de fatia de receita obtida dentro de cada partido e estado por candidatos a deputado federal em 2018
    
    - Nós contabilizamos o total de receitas, por candidato a Deputado Federal, obtidas de partidos políticos.
      Nessa etapa, não diferenciamos a esfera (municipal, estadual, nacional) da origem da verba.
    - Em seguida, calculamos o total recebido por candidatos num dado partido e estado, para calcular a 
      fração destinada a cada candidato.
 ***/

-- Tabela de receitas totais dos candidatos a Deputado Federal obtidas de partidos --
WITH total_receitas_partidarias AS (
  SELECT
    -- Info do candidato:
    sequencial_candidato,
    ANY_VALUE(nome_candidato) AS nome_candidato,
    ANY_VALUE(numero_urna_candidato) AS numero_urna_candidato,
    ANY_VALUE(cargo) AS cargo,
    ANY_VALUE(cpf_candidato_str) AS cpf_candidato_str,
    ANY_VALUE(sigla_unidade_eleitoral_candidato) AS sigla_unidade_eleitoral_candidato,
    ANY_VALUE(sigla_partido_candidato) AS sigla_partido_candidato,
    -- Valor total recebido de partidos:
    SUM(IF(tipo_receita = 'Pública' 
           AND nome_doador_rfb_unico != 'TRIBUNAL SUPERIOR ELEITORAL'
           AND nome_doador_rfb_unico NOT LIKE '%ELEICAO 201%'
           AND nome_doador_rfb_unico NOT LIKE '%ELEICOES 2004%'
           , valor_receita_unico, 0)) AS valor_candidato 

  FROM `gabinete-compartilhado.tratado_tse_processed.receitas_completas_2018`
  
  -- Seleciona apenas deputados federais:
  WHERE cargo IN ('1º Suplente', '2º Suplente', 'Senador')
  
  GROUP BY sequencial_candidato 
)

-- Tabela principal --
SELECT *, 
  SUM(valor_candidato) OVER (PARTITION BY sigla_partido_candidato, sigla_unidade_eleitoral_candidato) AS valor_partidario_estadual,
  SUM(valor_candidato) OVER (PARTITION BY sigla_partido_candidato) AS valor_partidario_total,
  SUM(valor_candidato) OVER (PARTITION BY sigla_unidade_eleitoral_candidato) AS valor_estadual_total,
  valor_candidato / IF(SUM(valor_candidato) OVER (PARTITION BY sigla_partido_candidato, sigla_unidade_eleitoral_candidato) = 0, 1, 
                       SUM(valor_candidato) OVER (PARTITION BY sigla_partido_candidato, sigla_unidade_eleitoral_candidato)) AS frac_partidario_estadual

FROM total_receitas_partidarias