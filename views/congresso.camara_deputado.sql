SELECT 
id,
cpf,
ultimoStatus.nomeEleitoral AS nome_parlamentar,
t2.sigla_nova AS sigla_partido,
ultimoStatus.siglaUf  AS sigla_uf,
nomeCivil AS nome_civil,
sexo,
ufNascimento AS uf_nascimento,
dataNascimento AS data_nascimento,
municipioNascimento AS municipio_nascimento,
escolaridade AS escolaridade,
ultimoStatus.idLegislatura AS ultima_legislatura,
ultimoStatus.urlFoto AS url_foto
FROM `gabinete-compartilhado.camara_v2.deputados_detalhes` t1
LEFT JOIN `gabinete-compartilhado.congresso.partidos_novas_siglas` t2 
ON t1.ultimoStatus.siglaPartido = t2.sigla_antiga 