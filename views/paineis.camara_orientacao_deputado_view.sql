SELECT t1.*, t2.*
FROM `gabinete-compartilhado.analise_congresso_votacoes.camara_orientacao_deputado`  t1
JOIN `gabinete-compartilhado.congresso.support_date_legislaturas` t2
ON DATE(timestamp) = aday