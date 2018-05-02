def schema = rman_prd

select db_key, (select name from &schema..rc_database d where d.db_key = r.db_key), count(*)
from &schema..rout r
group by db_key
order by count(*) desc;

select nvl(rout_text, '<null>') rout_text, count(*)
from rman_prd.rout
where db_key = &dbkey
group by nvl(rout_text, '<null>')
having count(*) > 100
order by count(*) desc;
