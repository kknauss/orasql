/*
set numwidth 20
column "AVG CR BLOCK RECEIVE TIME (ms)" format 9999999.9

select b1.inst_id, b2.value "GCS CR BLOCKS RECEIVED", b1.value "GCS CR BLOCK RECEIVE TIME",((b1.value / b2.value) * 10) "AVG CR BLOCK RECEIVE TIME (ms)"
from gv$sysstat b1, gv$sysstat b2
where b1.name = 'global cache cr block receive time' 
and b2.name = 'global cache cr blocks received' 
and b1.inst_id = b2.inst_id ;
*/

select username, machine, count(*)
from gv$session
where username = 'INTRANET_APPID'
group by username, machine
order by username, machine;


select	a.username, a.sid, a.serial#, lpad(c.spid,8) spid, server,
case a.status when 'ACTIVE' then 'A' when 'INACTIVE' then 'I' when 'KILLED' then 'K' else '?' end status, a.last_call_et, a.machine, 
a.osuser, a.program, a.sql_id, to_char(logon_time,'mm/dd/yy hh24:mi:ss') as logontime, 
a.event
from	gv$session a, gv$process c
where	a.inst_id = c.inst_id(+)
--and	type <> 'BACKGROUND'
and	a.paddr   = c.addr(+)
and	a.username = 'INTRANET_APPID'
order by last_call_et ;
--order by logontime desc;
