/* Cria tabelas para associar cada linha do DOU bruto a certos dados importantes */
WITH 

/* Data de publicação */
date_table AS 
(SELECT url, parse_date('%d/%m/%Y', value) AS pub_date
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'publicado-dou-data'),

/* Seção */
secao_table AS
--(SELECT url, CAST(SPLIT(SPLIT(value,'|')[OFFSET(0)],':')[OFFSET(1)] AS INT64) AS secao
(SELECT url, SPLIT(SPLIT(value,'|')[OFFSET(0)],':')[OFFSET(1)] AS secao 
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou` 
WHERE key = 'secao-dou'),

/* Orgão */
orgao_table AS
(SELECT url, value AS orgao
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'orgao-dou-data'),

/* Quem assina */
assina_table AS
(SELECT url, value AS assina
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'assina'),

/* Identificação do artigo */
identifica_table AS
(SELECT url, value AS identifica
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'identifica'),

/* Identificação do cargo do assinante */
cargo_table AS
(SELECT url, value AS cargo
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'cargo'),

/* Página do DOU */
pagina_table AS
(SELECT url, value AS pagina
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'secao-dou-data'),

/* Edição do DOU */
edicao_table AS
(SELECT url, value AS edicao
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'edicao-dou-data'),

/* Palavras enfatizadas */
italico_table AS
(SELECT url, value AS italico
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'dou-em'),

/* Ementa */
ementa_table AS
(SELECT url, value AS ementa
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'ementa'),

/* Palavras enfatizadas / títulos */
strong_table AS
(SELECT url, value AS strong
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'dou-strong'),

/* Aparentamente o órgão de um ato do executivo */
ato_orgao_table AS
(SELECT url, value AS ato_orgao
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'titulo'),

/* Sub-título de artigos */
subtitulo_table AS
(SELECT url, value AS subtitulo
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'subtitulo'),

/* Parágrafo e resumo dos artigos */
paragraph_table AS
(SELECT url, value AS paragraph,

CASE ARRAY_LENGTH(split(value, '|')) > 1
WHEN FALSE THEN
substr(value, 300) 
ELSE
concat(substr(split(value, '|')[offset(0)],1,200), '... | ...', substr(split(value, '|')[offset(1)],1,200))
END AS resumo

FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`
WHERE key = 'dou-paragraph'),

/* Linhas únicas de cada artigo */
ref_table AS
(SELECT DISTINCT url, capture_date, url_certificado
FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou`)

/* Cria a tabela com as colunas extras */
SELECT 
/* Colunas de identificação, comuns ao artigo */
PARSE_DATETIME('%Y-%m-%d %H:%M:%S', ref.capture_date) AS capture_date,
ref.url, ref.url_certificado,
/* Entradas chave */
date_table.pub_date, secao_table.secao, edicao_table.edicao, pagina_table.pagina, 
identifica_table.identifica, orgao_table.orgao, assina_table.assina, cargo_table.cargo,  
/* Entradas com texto a serem buscadas */
ato_orgao_table.ato_orgao, subtitulo_table.subtitulo, ementa_table.ementa, 
strong_table.strong, italico_table.italico, paragraph_table.paragraph,
CONCAT(IFNULL(ato_orgao_table.ato_orgao,''), ' | ', IFNULL(subtitulo_table.subtitulo,''), ' | ', 
       IFNULL(ementa_table.ementa,''), ' | ', IFNULL(strong_table.strong,''), ' | ', 
       IFNULL(italico_table.italico,''), ' | ', IFNULL(paragraph_table.paragraph, '')) AS alltext,
/* Entradas auxiliares */
paragraph_table.resumo 

/* Join com as tabelas de cada key */
FROM ref_table AS ref
LEFT JOIN       date_table ON ref.url =       date_table.url
LEFT JOIN      secao_table ON ref.url =      secao_table.url
LEFT JOIN      orgao_table ON ref.url =      orgao_table.url
LEFT JOIN     assina_table ON ref.url =     assina_table.url
LEFT JOIN identifica_table ON ref.url = identifica_table.url
LEFT JOIN      cargo_table ON ref.url =      cargo_table.url
LEFT JOIN     pagina_table ON ref.url =     pagina_table.url
LEFT JOIN     edicao_table ON ref.url =     edicao_table.url
LEFT JOIN    italico_table ON ref.url =    italico_table.url
LEFT JOIN     ementa_table ON ref.url =     ementa_table.url
LEFT JOIN     strong_table ON ref.url =     strong_table.url
LEFT JOIN  ato_orgao_table ON ref.url =  ato_orgao_table.url
LEFT JOIN  subtitulo_table ON ref.url =  subtitulo_table.url
LEFT JOIN  paragraph_table ON ref.url =  paragraph_table.url
