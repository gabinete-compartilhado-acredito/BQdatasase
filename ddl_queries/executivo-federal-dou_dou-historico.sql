CREATE EXTERNAL TABLE `gabinete-compartilhado.executivo_federal_dou.dou_historico`
 (
texto_html STRING,
texto STRING,
subtitulo STRING,
data STRING,
titulo STRING,
ementa STRING,
identifica STRING,
autores STRUCT<assina ARRAY<STRING>, cargo ARRAY<STRING> >,
art_artcategory STRING,
art_artsection STRING,
art_artsize INT64,
art_artnotes STRING,
art_artclass STRING,
art_arttype STRING,
art_highlight STRING,
art_highlightimage STRING,
art_highlightpriority STRING,
art_highlighttype STRING,
art_idmateria INT64,
art_editionnumber STRING,
art_pdfpage STRING,
art_id INT64,
art_highlightimagename STRING,
art_pubdate STRING,
art_idoficio INT64,
art_pubname STRING,
art_name STRING,
art_numberpage STRING,
capture_date TIMESTAMP
)

WITH PARTITION COLUMNS
OPTIONS(
  format="NEWLINE_DELIMITED_JSON",
  hive_partition_uri_prefix="gs://brutos-publicos/executivo/federal/dou_historico/",
  uris=["gs://brutos-publicos/executivo/federal/dou_historico/*historical_dou.json"]
);
