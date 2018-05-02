column username format   a18;
column sid      format 99999;
column machine  format   a22;
column sql_text format   a80;


select a.inst_id, a.username, a.sid, a.serial#, c.spid, a.last_call_et, a.status, b.sql_text
from gv$session a, gv$sqlarea b, gv$process c
where a.inst_id      = &inst
and  c.spid          = &spid
and a.sql_hash_value = b.hash_value(+)
and a.paddr          = c.addr
and a.inst_id        = c.inst_id
and a.inst_id        = b.inst_id
order by spid, a.sid, a.serial#;
