/***
    Consolida as informações sobre pertencimento de bancada numa única string, para cada deputado.
 ***/

SELECT 
  id, nome_deputado,
  CONCAT(
    IF(ruralista        = 1, "Ruralista\n", ""),
    IF(evangelica       = 1, "Evangélica\n", ""),
    IF(construtoras     = 1, "Construtoras\n", ""),
    IF(empresarial      = 1, "Empresarial\n", ""),
    IF(mineracao        = 1, "Mineração\n", ""),
    IF(bala             = 1, "Bala\n", ""),
    IF(saude            = 1, "Saúde\n", ""),
    IF(sindical         = 1, "Sindical\n", ""),
    IF(bola             = 1, "Bola\n", ""),
    IF(direitos_humanos = 1, "Direitos humanos\n", ""),
    IF(parentes         = 1, "Parentes\n", "")
    ) AS bancadas,
  SPLIT(REGEXP_REPLACE(CONCAT(
      IF(ruralista        = 1, "Ruralista/", ""),
      IF(evangelica       = 1, "Evangélica/", ""),
      IF(construtoras     = 1, "Construtoras/", ""),
      IF(empresarial      = 1, "Empresarial/", ""),
      IF(mineracao        = 1, "Mineração/", ""),
      IF(bala             = 1, "Bala/", ""),
      IF(saude            = 1, "Saúde/", ""),
      IF(sindical         = 1, "Sindical/", ""),
      IF(bola             = 1, "Bola/", ""),
      IF(direitos_humanos = 1, "Direitos humanos/", ""),
      IF(parentes         = 1, "Parentes/", "")), 
      r"/$", ""), "/") 
       AS array_bancadas
    
FROM `gabinete-compartilhado.bruto_gabinete_administrativo.camara_bancadas_publica_2016`