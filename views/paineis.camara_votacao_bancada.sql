SELECT t1.*, t2.*
FROM `gabinete-compartilhado.congresso.camara_votacao_bancada`  t1
JOIN `gabinete-compartilhado.congresso.support_date_legislaturas` t2
ON DATE(timestamp) = aday