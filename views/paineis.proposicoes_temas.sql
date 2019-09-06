SELECT t1.*, t2.data_apresentacao
FROM `gabinete-compartilhado.congresso.proposicoes_temas` t1
JOIN `gabinete-compartilhado.paineis.proposicoes_proposicoes`  t2
ON t1.id =  t2.id 