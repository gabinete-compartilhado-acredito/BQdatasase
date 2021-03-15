/***
    Tabela de identificação de matérias do senado com as da câmara ou outras do senado (ou congresso nacional).
    
    Esta tabela mostra o ID de proposições no Senado e, na maioria dos casos, a quais IDs essas proposições 
    correspondem na câmara (no caso de proposições que tramitaram de uma casa à outra). Essa tabela também mostra
    associações entre proposições no Senado (no caso de MPVs que viram PLVs, projetos que se iniciam no Senado, 
    vão para a Câmara e voltam para o Senado, MPVs que são reeditadas).
    
    O tipo das proposições listadas nesta tabela estão restritos a:
    ('PEC', 'PL', 'PLC', 'PLS', 'PLN', 'PLP', 'PLV', 'MPV', 'PDL', 'PDN', 'PDR', 'PDS', 'PDC')
    Essa restrição foi feita porque as proposições do senado possuem como "Outros números" muitas
    proposições auxiliares, do tipo MSG.
    
    - As colunas com sufixo '_senado' trazem a identificação no Senado da proposição em questão.
    - As colunas com sufixo '_outros' trazem a identificação no Senado ou na Câmara, a depender 
      do id_outros (o id_outros só contém algo quando a proposição é do Senado).
    - A coluna 'casa_outros' deveria dizer se a Proposição '_outros' corresponde à Câmara ou Senado
      mas ela erra às vezes.
    - As colunas com o sufixo '_camara' trazem a identificação na Câmara.
    
    ATENÇÃO:
    -- Algumas matérias '_senado' estão associadas a mais de uma matéria '_outros' (e quando a outros 
       é do Senado, esta também aparece entre as '_senado'). Essas com repetição correspondem a 0.5% 
       das proposições do Senado com alguma matéria '_outros' associada.
    -- Quando o número de uma proposição na câmara, de acordo com a base do Senado, inclui a letra E,
       ela foi associada à proposição sem E.
    ** Algumas proposições foram renumeradas na câmara, e o número na base do Senado permaneceu o antigo.
       Essas proposições acabam não tendo a correspondência com o Senado efetivada.
 ***/

WITH outros_do_senado AS (
  SELECT 
    -- ID da proposição na base do senado:
    p.Codigo_Materia AS id_senado, 
    p.Sigla_Subtipo_Materia AS sigla_tipo_senado, 
    p.Numero_Materia AS numero_senado, 
    p.Ano_Materia AS ano_senado, 
    -- Info sobre a relação entre as casas:
    p.Sigla_Casa_Iniciadora AS casa_iniciadora,
    p.Descricao_Objetivo_Processo AS objetivo_processo,
    -- Outros IDs (seleciona ID da Câmara se for o caso):
    o.DescricaoTipoNumeracao AS tipo_numeracao_outros,
    O.IdentificacaoMateria.SiglaCasaIdentificacaoMateria AS casa_outros,
    o.IdentificacaoMateria.CodigoMateria AS id_outros,
    o.IdentificacaoMateria.SiglaSubtipoMateria As sigla_tipo_outros,
    o.IdentificacaoMateria.NumeroMateria AS numero_outros,
    o.IdentificacaoMateria.AnoMateria AS ano_outros
    --c.data_apresentacao AS apresentacao_camara

  FROM 
    -- Expande os arrays de "outros números" das proposições:
    `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p,
     UNNEST(p.Outro_Numero_Materia) AS o

  WHERE
    Sigla_Subtipo_Materia IN ('PEC', 'PL', 'PLC', 'PLS', 'PLN', 'PLP', 'PLV', 'MPV', 'PDL', 'PDN', 'PDR', 'PDS', 'PDC')
    AND o.IdentificacaoMateria.SiglaSubtipoMateria IN ('PEC', 'PL', 'PLC', 'PLS', 'PLN', 'PLP', 'PLV', 'MPV', 'PDL', 'PDN', 'PDR', 'PDS', 'PDC')
)

  -- Tabela de proposições do senado com correspondências na câmara (ou no próprio senado), junto com IDs da Câmara -- 
  SELECT
    -- Proposições do Senado:
    s.id_senado, s.sigla_tipo_senado, s.numero_senado, s.ano_senado, 
    s.casa_iniciadora, s.objetivo_processo AS objetivo_processo_senado, 
    -- Outros identificadores (números) das proposições do Senado, segundo a base do Senado:
    s.tipo_numeracao_outros, s.casa_outros, 
    s.id_outros, s.sigla_tipo_outros, s.numero_outros, s.ano_outros,
    -- Proposições da Câmara:
    c.id AS id_camara, c.siglaTipo AS sigla_tipo_camara, c.numero AS numero_camara, c.ano AS ano_camara

  FROM 
    outros_do_senado AS s
    -- Junta com lista de proposições da câmara:
    FULL OUTER JOIN `gabinete-compartilhado.camara_v2_processed.proposicoes_cleaned` AS c
    ON
      s.id_outros IS NULL AND
      s.sigla_tipo_outros = c.siglaTipo AND
      SAFE_CAST(REPLACE(s.numero_outros, 'E', '') AS INT64) = c.numero AND
      s.ano_outros = c.ano

  WHERE c.siglaTipo IN ('PEC', 'PL', 'PLC', 'PLS', 'PLN', 'PLP', 'PLV', 'MPV', 'PDL', 'PDN', 'PDR', 'PDS', 'PDC') OR c.siglaTipo IS NULL

UNION ALL

  -- Tabela com proposições do senado sem nenhuma proposição em "Outros números" --
  SELECT 
    -- ID da proposição na base do senado:
    p.Codigo_Materia AS id_senado, 
    p.Sigla_Subtipo_Materia AS sigla_tipo_senado, 
    p.Numero_Materia AS numero_senado, 
    p.Ano_Materia AS ano_senado,
    -- Info sobre a relação entre as casas:
    p.Sigla_Casa_Iniciadora AS casa_iniciadora,
    p.Descricao_Objetivo_Processo AS objetivo_processo,
    -- Outros IDs (seleciona ID da Câmara se for o caso):
    NULL AS tipo_numeracao_outros,
    NULL AS casa_outros,
    NULL AS id_outros,
    NULL As sigla_tipo_outros,
    NULL AS numero_outros,
    NULL AS ano_outros,
    NULL AS id_camara, 
    NULL AS sigla_tipo_camara, 
    NULL AS numero_camara,
    NULL AS ano_camara
    --NULL AS apresentacao_camara

  FROM `gabinete-compartilhado.senado_processed.proposicoes_cleaned` AS p
  WHERE Outro_Numero_Materia IS NULL
  AND Sigla_Subtipo_Materia IN ('PEC', 'PL', 'PLC', 'PLS', 'PLN', 'PLP', 'PLV', 'MPV', 'PDL', 'PDN', 'PDR', 'PDS', 'PDC')
