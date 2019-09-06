SELECT w1.*,
w2.*
FROM (
SELECT t1.*, 
t2.id as id_parlamentar, t2.nome_parlamentar, t2.sigla_partido, t2.sigla_uf
FROM `gabinete-compartilhado.congresso.tramitacao` t1
JOIN `gabinete-compartilhado.congresso.camara_deputado` t2
ON lower(t1.despacho) LIKE CONCAT('%', lower(t2.nome_parlamentar), '%')) w1
JOIN `gabinete-compartilhado.congresso.support_date_legislaturas` w2
ON EXTRACT(DATE FROM w1.data_hora) = w2.aday 
