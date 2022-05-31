
/***
     Tabela de detecção de nomeações e exonerações no DOU:
     -- Ela seleciona matérias da seção 2 com os regex de nomeação e exoneração abaixos;
     -- Nessas matérias, procura por padrões de texto que permitam extrair automaticamente o nome dos exonerados/nomeados;
     -- Esse padrão envolve, principalmente, escrever o nome das pessoas em caixa alta e a uma distância mínima (em caracteres) 
        do termo que identifica o ato (e.g. "Nomear" ou "Exonerar").
        >> Existem casos nos quais o nome das pessoas não estão em caixa alta, o que faz a detecção do nome falhar;
        >> Existem casos nos quais a distância entre o termo identificador e o nome é muito grande, o que faz a detecção do nome falhar;
     -- Se os regex que identificam nomeações/exonerações forem encontrados mas o padrão para os nomes não, a coluna do nome estará vazia.
        Isso indica que foi encontrada uma nomeação ou exoneração que precisa ser analisada manualmente.
 ***/


-- Regex utilizadas para detectar matérias com nomeações e exonerações:
-- DECLARE regex_nomeacao   STRING DEFAULT r'nomear';
-- DECLARE regex_exoneracao STRING DEFAULT r'exonerar|exonerad[ao]';


-- Tabela auxiliar: constrói array de detecções de nomeações e de exonerações para cada matéria --
WITH exonomeia AS (
  SELECT 
    orgao, data_pub,
    
    -- Detecta nomeações pelo termo "Nomear" acompanhado de letras maiúsculas (que esperamos ser nomes):
    REGEXP_EXTRACT_ALL(clean_text, r"([Nn](?:omear|OMEAR).{0,100}?[A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})") AS nomeacao_texto, -- Extrai o texto da nomeação.
    REGEXP_EXTRACT_ALL(clean_text, r"[Nn](?:omear|OMEAR).{0,100}?([A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})") AS nomeacao_nome,  -- Extrai apenas o nome do nomeado.
        
    -- Detecta exonerações pelo termo "Exonerar" (1 regex) ou "Exonerado(a)" (2o regex) acompanhado de letras maiúsculas (que esperamos ser nomes):
    ARRAY_CONCAT(REGEXP_EXTRACT_ALL(clean_text, r"([Ee](?:xonerar|XONERAR).{0,100}?[A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})"),
                 REGEXP_EXTRACT_ALL(clean_text, r"([Ee](?:xonerad[ao]|XONERAD[AO])[^\.]{0,50}?[A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})")) AS exoneracao_texto, -- Extrai o texto da exoneração.
    ARRAY_CONCAT(REGEXP_EXTRACT_ALL(clean_text, r"[Ee](?:xonerar|XONERAR).{0,100}?([A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})"),
                 REGEXP_EXTRACT_ALL(clean_text, r"[Ee](?:xonerad[ao]|XONERAD[AO])[^\.]{0,50}?([A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})")) AS exoneracao_nome, -- Extrai o nome do exonerado.

/*
  -- Detecta designações pelo termo "Designar" acompanhado de letras maiúsculas (que esperamos ser nomes):
    REGEXP_EXTRACT_ALL(clean_text, r"([Dd](?:esignar|ESIGNAR).{0,100}?[A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})") AS designacao_texto, -- Extrai o texto da designação.
    REGEXP_EXTRACT_ALL(clean_text, r"[Dd](?:esignar|ESIGNAR).{0,100}?([A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})") AS designacao_nome,  -- Extrai apenas o nome do designado.
        
    -- Detecta exonerações pelo termo "Dispensar" (1 regex) ou "Dispensado(a)" (2o regex) acompanhado de letras maiúsculas (que esperamos ser nomes):
    ARRAY_CONCAT(REGEXP_EXTRACT_ALL(clean_text, r"([Dd](?:ispensar|ISPENSAR).{0,100}?[A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})"),
                 REGEXP_EXTRACT_ALL(clean_text, r"([Dd](?:ispensad[ao]|INSPENSAD[AO])[^\.]{0,50}?[A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})")) AS dispensa_texto, -- Extrai o texto da dispensa.
    ARRAY_CONCAT(REGEXP_EXTRACT_ALL(clean_text, r"[Dd](?:ispensar|ISPENSAR).{0,100}?([A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})"),
                 REGEXP_EXTRACT_ALL(clean_text, r"[Dd](?:ispensad[ao]|INSPENSAD[AO])[^\.]{0,50}?([A-ZÇÃÁÂÉÊÍÓÔÚ'\- ]{10,})")) AS dispensa_nome, -- Extrai o nome do dispensado.
*/
    clean_text, assina, identifica, url,
    -- Colunas de partição:
    part_data_pub, part_secao

  FROM `gabinete-compartilhado.executivo_federal_dou.materias_campos_cleaned`  

  WHERE secao = 2 AND
  -- Palavras-chave que indicam exonerações/nomeações:
  REGEXP_CONTAINS(LOWER(clean_text), CONCAT(r'(?:', 'nomear', '|', 'exonerar|exonerad[ao]', ')'))
  --REGEXP_CONTAINS(LOWER(clean_text), CONCAT(r'(?:', 'nomear', '|', 'exonerar|exonerad[ao]', '|', 'designar', '|', 'dispensar|dispensad[ao]', ')'))
)


-- Tabela principal --

-- Nomeações:
SELECT 
  orgao, data_pub, 'Nomeação' AS ato,
  TRIM(nomeacao_nome) AS nome, nomeacao_texto AS texto,
  clean_text, assina, identifica, url,
  part_data_pub, part_secao

FROM exonomeia, 
UNNEST(exonomeia.nomeacao_texto) AS nomeacao_texto WITH OFFSET nomeacao_texto_idx,
UNNEST(exonomeia.nomeacao_nome) AS nomeacao_nome WITH OFFSET nomeacao_nome_idx
WHERE nomeacao_texto_idx = nomeacao_nome_idx

UNION ALL

-- Exonerações:
SELECT 
  orgao, data_pub, 'Exoneração' AS ato,
  TRIM(exoneracao_nome) AS nome, exoneracao_texto AS texto,
  clean_text, assina, identifica, url,
  part_data_pub, part_secao 

FROM exonomeia, 
UNNEST(exonomeia.exoneracao_texto) AS exoneracao_texto WITH OFFSET exoneracao_texto_idx,
UNNEST(exonomeia.exoneracao_nome) AS exoneracao_nome WITH OFFSET exoneracao_nome_idx
WHERE exoneracao_texto_idx = exoneracao_nome_idx

UNION ALL

-- Nomeações não parseadas:
SELECT 
  orgao, data_pub, 'Nomeação' AS ato,
  NULL AS nome, NULL AS texto,
  clean_text, assina, identifica, url,
  part_data_pub, part_secao 

FROM exonomeia
WHERE ARRAY_LENGTH(nomeacao_texto) = 0 AND ARRAY_LENGTH(exoneracao_texto) = 0
AND REGEXP_CONTAINS(LOWER(clean_text), CONCAT(r'(?:', 'nomear', ')'))

UNION ALL

-- Exonerações não parseadas:
SELECT 
  orgao, data_pub, 'Exoneração' AS ato,
  NULL AS nome, NULL AS texto,
  clean_text, assina, identifica, url,
  part_data_pub, part_secao 

FROM exonomeia
WHERE ARRAY_LENGTH(nomeacao_texto) = 0 AND ARRAY_LENGTH(exoneracao_texto) = 0
AND REGEXP_CONTAINS(LOWER(clean_text), CONCAT(r'(?:', 'exonerar|exonerad[ao]', ')'))


ORDER BY data_pub

--AND REGEXP_CONTAINS(LOWER(clean_text), r'(?:ministério\s*da\s*saúde|ministro.{1,20}saúde)')
