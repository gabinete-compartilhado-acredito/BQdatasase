/***
    Limpeza dos registros históricos do DOU, baixados dos dados 
    abertos da Imprensa Nacional em formato XML.
    - Renomeamos e reordenamos as colunas;
    - Colunas com strings '' viraram NULLs;
    - Criamos novas colunas do número da edição, separando a letra do número.
 ***/

SELECT 

    -- ID da matéria:
    identifica,
    art_arttype AS tipo_materia,
    art_name AS tag_materia,
    -- Data de publicação:
    PARSE_DATE("%d/%m/%Y", art_pubdate) AS data_pub,
    -- Órgão:
    art_artcategory AS orgao_completo, -- O mesmo que o órgão na raspagem do DOU, ou pode ter só trechos dos órgãos.
    art_artsection AS orgao_section,   
    titulo AS orgao_titulo,            -- Em geral é NULL, às vezes é o órgão (especialmente em "Atos do Poder Executivo").
    subtitulo AS orgao_subtitulo,      -- Em geral é NULL, às vezes é um órgão subordinado, às vezes são coisas como "ANEXO". 

    -- Texto e partes do texto:
    ementa,                            -- Às vezes não é ementa, é um trecho qualquer de texto.
    texto, 
    texto_html, 
    data AS data_ou_assinatura,        -- Pode estar NULL, conter a data do ato, por extenso, ou o nome de alguém que assina o ato.
    autores.assina AS assinaturas,     -- Array de assinaturas
    autores.cargo AS cargos,           -- Array de cargos referentes aos assinantes de `assinaturas`.
    -- Localização da matéria:
    art_pubname AS sigla_secao,
    art_editionnumber AS edicao_completa,
    CAST(REGEXP_EXTRACT(art_editionnumber, r'\d{1,4}') AS INT64) AS edicao_numero,
    REGEXP_EXTRACT(art_editionnumber, r'[A-Za-z]') AS edicao_extra, -- A, B, C, ... ou NULL.
    art_numberpage AS pagina, 

    -- Outras informações:
    art_artnotes AS comentarios,                                                                 -- Em geral vazio, mas quando tem, parecem comentários livres. 
    -- Dados para destaque (quase sempre vazios):
    IF(TRIM(art_highlighttype) = '', NULL, art_highlighttype) AS highlight_destaque,             -- Quase sempre está vazio, quando não está é "Destaques Do Diário Oficial da União" (ligado ao caso abaixo).  
    IF(TRIM(art_highlightpriority) = '', NULL, art_highlightpriority) AS highlight_priority,     -- Quase sempre está vazio, quando tem alguma coisa é um número inteiro de um dígito (ligado ao caso acima).
    IF(TRIM(art_highlight) = '', NULL, art_highlight) AS highlight_text,                         -- Quase sempre está vazio. Quando não está, contém uma descrição do conteúdo da matéria.
    IF(TRIM(art_highlightimage) = '', NULL, art_highlightimage) AS highlight_image,              -- Quase sempre está vazio. 
    IF(TRIM(art_highlightimagename) = '', NULL, art_highlightimagename) AS highlight_image_name, -- Quase sempre está vazio.
    -- Informações inúteis:
    art_artsize AS article_size, 

    -- URLs:
    art_pdfpage AS url_certificado,
    -- Info da captura:
    capture_date,
    -- IDs:
    art_id AS id_article,
    art_idmateria AS id_materia,
    art_idoficio AS id_oficio,
    art_artclass AS classificacao, 
    -- Partição dos dados:
    part_secao, 
    part_data_pub

FROM `gabinete-compartilhado.executivo_federal_dou.dou_historico`