SELECT

-- Conteúdo do artigo:
identifica, -- Título do artigo (e.g. Portaria N° 123 de 2019) 
            -- PS: Pode haver múltiplos títulos de artigos diferentes num mesmo "artigo", separados por " | "
orgao,      -- Órgão que publicou o artigo (e.g. Ministério da Educação/Secretaria de Ensino Superior)
ementa,     -- Ementa do artigo
resumo,     -- Resumo criado pela captura

-- Texto completo do artigo (fulltext) sem os cabeçalhos, rodapés, títulos (identifica) e ementa:
IF (identifica IS NULL,
  fulltext,
  IF(ementa IS NULL,

    -- Se artigo não tem ementa:
    -- Remove rodapé:
    REPLACE(
      -- Pega texto a partir do final do primeiro "identifica":
      SUBSTR(fulltext,
             -- Acha a posição do final do primeiro título (identifica):
             STRPOS(fulltext, IF(ARRAY_LENGTH(SPLIT(identifica,' | ')) > 1, 
                                 SPLIT(identifica,' | ')[OFFSET(0)], 
                                 identifica)
                    ) 
             + LENGTH(IF(ARRAY_LENGTH(SPLIT(identifica,' | ')) > 1,                                                                                                              SPLIT(identifica,' | ')[OFFSET(0)], 
                         identifica)
                      )
             ), 
      'Este conteúdo não substitui o publicado na versão certificada.', ''),
    -- Se o artigo tem ementa:
    -- Remove a ementa:
    REPLACE(
      -- Remove rodapé:
      REPLACE(
        -- Pega texto a partir do final do primeiro "identifica":
        SUBSTR(fulltext,
               -- Acha a posição do final do primeiro título (identifica):
               STRPOS(fulltext, IF(ARRAY_LENGTH(SPLIT(identifica,' | ')) > 1, 
                                   SPLIT(identifica,' | ')[OFFSET(0)], 
                                   identifica)
                      ) 
               + LENGTH(IF(ARRAY_LENGTH(SPLIT(identifica,' | ')) > 1,                                                                                                              SPLIT(identifica,' | ')[OFFSET(0)], 
                           identifica)
                        )
               ), 
        'Este conteúdo não substitui o publicado na versão certificada.', ''), 
      ementa, '')
  ) 
) AS clean_text,

fulltext,   -- Texto completo do artigo, sem processamento
alltext,    -- Antigo texto completo, onde tags são agrupados e texto fica fora da ordem
paragrafos, -- Todos os parágrafos
assina,     -- Quem assinou o artigo
cargo,      -- Cargo de quem assinou o artigo
-- Id do artigo:
secao,      -- Seção onde o artigo foi publicado (1, 2, 3)
edicao,     -- Edição em que o artigo foi publicado (e.g. 56, 78-B)
tipo_edicao, -- Criada pelo view anterior, se é "Ordinária" ou "Extra"
pagina,      -- Página do DOU onde foi publicado o artigo
data_pub,    -- Data de publicação
-- Links:
url,         -- URL para o artigo em HTML
url_certificado, -- URL para o artigo certificado, acho que em PDF
-- Info da captura:
capture_date     -- Data de captura do artigo
-- Colunas de partição dos dados:
part_data_pub,
part_secao

FROM `gabinete-compartilhado.executivo_federal_dou.materias_campos_selecionados`
