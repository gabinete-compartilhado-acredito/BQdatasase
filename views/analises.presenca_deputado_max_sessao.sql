with d as (select idDeputado,  extract(day from dataHoraInicio) as day,
extract(month from dataHoraInicio) as month,
extract(year from dataHoraInicio) as year,
count(*) as n_sessao
from `gabinete-compartilhado.camara_v2.eventos_presenca_deputados` 
group by idDeputado, extract(day from dataHoraInicio),  extract(month from dataHoraInicio),  extract(year from dataHoraInicio))

select t1.idDeputado, day, month, year, max_sessao
from d t1
join (select idDeputado, MAX(n_sessao) as max_sessao
from d
group by idDeputado) t2
on t1.idDeputado = t2.idDeputado
order by max_sessao DESC