set verify off;

column spid                  heading 'Server|PID';
column sid      format 999999            heading 'SID';
column server                heading 'Server|Type';
column last_call_et          heading 'Last Call|Elap(sec)';
column event    format a30   heading 'Wait Event';
column machine  format a22   heading 'Machine';
column program  format a22   heading 'Program';
column username format a15   heading 'Username';
column status   format  a8   heading 'Status';
column sql_text format a40   heading 'SQL Text';


select a.inst_id, c.spid, a.username, a.sid, a.serial#, server, machine, a.program,  a.status, a.sql_id, a.last_call_et, a.event, b.sql_text
from gv$session a, gv$sqlarea b, gv$process c
where 1=1
and a.inst_id        = b.inst_id(+)
and a.sql_hash_value = b.hash_value(+)
and a.inst_id        = c.inst_id(+)
and a.paddr          = c.addr(+)
and a.inst_id        = &&inst_id
and a.sid            = &&sid
order by sid, serial#;

