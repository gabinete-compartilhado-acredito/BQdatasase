/***
     Selecionamos apenas os links do scrap do Brasil Real Oficial 
     que apontam para artigos do DOU. Além disso: 
     - extraí uma coluna com a data de publicação no Brasil Real Oficial;
     - coloquei nova coluna com certa padronização do link, para poder cruzar
       com base do DOU.
 ***/

SELECT
  -- Data de publicação no Brasil Real Oficial:
  PARSE_DATE('%d.%m.%y', REGEXP_EXTRACT(title_link, r'\d{2}\.\d{2}\.\d{2}')) AS data_pub,
  -- Título da publicação no Brasil Real Oficial:
  title_link,
  -- Texto do link no Brasil Real Oficial:
  dou_link,
  -- Link para o artigo do DOU:
  dou_link_href,
  REPLACE(dou_link_href, 'http://www.in.gov.br/en/', 'http://www.in.gov.br/') AS dou_link_cleaned

FROM `gabinete-compartilhado.executivo_federal_dou.brasil_real_oficial`
WHERE dou_link_href LIKE '%www.in.gov.br%'