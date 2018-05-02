/*
select s.event, s.* from gv$session s where status <> 'INACTIVE';
select s.event, s.* from gv$session s where sid = 2237 and inst_id = 5; 
select s.event, s.* from gv$session s where sid = 2131 and inst_id = 5;
*/

select c.inst_id, c.spid, a.*
from gv$session a, gv$process c
where a.paddr = c.addr
and a.inst_id = c.inst_id
and a.event = 'virtual circuit status'
and a.type <> 'BACKGROUND'
and a.status <> 'INACTIVE'
order by last_call_et desc;