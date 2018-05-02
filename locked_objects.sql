
select /*+RULE */ 
	s.username, o.name "Locked object", l.sid, s.serial#, p.spid, l.type, round(l.ctime/60,0) "Minutes", 
	decode(l.lmode,'1','-','2','RS','3','RX','4','S','5','SRX','6','X') "Mode", 
	substr(s.osuser,1,16)"OS user",
	s.machine "Machine", substr(s.terminal,1,16) "Terminal"
--, lo.*
from v$process p, sys.obj$ o, v$session s, v$lock l, v$locked_object lo
where l.sid = lo.session_id and l.sid > 5
and (l.id2 = lo.xidsqn or l.id1 = lo.object_id)
and s.sid = lo.session_id and o.obj# = lo.object_id
and p.addr = s.paddr
--and o.name = 'MTG_COC'
order by round(l.ctime/60,0) desc, o.name;
