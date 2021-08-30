# destination_table: analise_congresso_atividade.tramitacao_por_parlamentar_

CREATE TEMP FUNCTION accent2latin(word STRING) AS
((
  WITH lookups AS (
    SELECT 
    'ã,ç,æ,œ,á,é,í,ó,ú,à,è,ì,ò,ù,ä,ë,ï,ö,ü,ÿ,â,ê,î,ô,û,å,ø,Ø,Å,Á,À,Â,Ä,Ã,È,É,Ê,Ë,Í,Î,Ï,Ì,Ò,Ó,Ô,Ö,Õ,Ú,Ù,Û,Ü,Ÿ,Ç,Æ,Œ,ñ' AS accents,
    'a,c,ae,oe,a,e,i,o,u,a,e,i,o,u,a,e,i,o,u,y,a,e,i,o,u,a,o,O,A,A,A,A,A,A,E,E,E,E,I,I,I,I,O,O,O,O,O,U,U,U,U,Y,C,AE,OE,n' AS latins
  ),
  pairs AS (
    SELECT accent, latin FROM lookups, 
      UNNEST(SPLIT(accents)) AS accent WITH OFFSET AS p1, 
      UNNEST(SPLIT(latins)) AS latin WITH OFFSET AS p2
    WHERE p1 = p2
  )
  SELECT STRING_AGG(IFNULL(latin, char), '')
  FROM UNNEST(SPLIT(word, '')) char
  LEFT JOIN pairs
  ON char = accent
));

--SELECT *
--FROM (
SELECT 
w1.*,
w2.*
FROM (
SELECT t1.*, 
t2.id as id_parlamentar, t2.nome_parlamentar, t2.sigla_partido, t2.sigla_uf
FROM (SELECT * FROM `gabinete-compartilhado.congresso.tramitacao_` WHERE data_hora BETWEEN DATETIME '2019-02-01' AND DATETIME '2022-12-31') t1
JOIN (SELECT * FROM `gabinete-compartilhado.congresso.camara_deputado_` WHERE ultima_legislatura = 56 ORDER BY nome_parlamentar)  t2
ON accent2latin(lower(t1.despacho)) LIKE CONCAT('%', accent2latin(lower(t2.nome_parlamentar)), '%')) w1
JOIN `gabinete-compartilhado.congresso.support_date_legislaturas` w2
ON EXTRACT(DATE FROM w1.data_hora) = w2.aday
--) k1
--JOIN `gabinete-compartilhado.congresso.camara_deputados_semihomonimos` k2
--ON lower(k1.nome_parlamentar) = k2.nome
--AND NOT REGEXP_CONTAINS(accent2latin(lower(k1.nome_parlamentar)), accent2latin(k2.regex))

   
