SELECT key, count(key) AS counter FROM `gabinete-compartilhado.executivo_federal_dou.bruto_dou` 
GROUP BY key
ORDER BY counter