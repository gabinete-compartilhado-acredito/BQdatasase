select t1.nome, t2.sigla_nova, t1.total_membros 
from `gabinete-compartilhado.analise_congresso_poder.camara_bloco_numero_membros` as t1 
left join `gabinete-compartilhado.congresso.partidos_novas_siglas` as t2
on t1.nome = t2.sigla_antiga