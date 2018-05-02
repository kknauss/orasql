set linesize 170;
set pagesize 55;
column username format a8;
column sid format 99999;
column machine format a22



select c.spid, substr(a.username, 1,10) as username, a.sid, a.status, a.machine, a.program
from gv$session a, gv$process c
where a.paddr = c.addr
and a.inst_id = c.inst_id
and a.inst_id = &inst_id
and a.sid     = &sid
order by spid, a.sid, a.serial#;
