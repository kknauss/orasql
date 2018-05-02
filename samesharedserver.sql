set verify off;

column spid                  heading 'Server|PID';
column server                heading 'Server|Type';
column last_call_et          heading 'Last Call|Elap(sec)';
column event    format a30   heading 'Wait Event';
column machine  format a22   heading 'Machine';
column program  format a22   heading 'Program';
column username format a13   heading 'Username';
column status   format  a8   heading 'Status';
column sql_text format a40   heading 'SQL Text';


select a.inst_id, c.spid, a.username, a.sid, a.serial#, server, machine, a.program,  a.status, a.last_call_et, a.event
from gv$session a, gv$process c
where 
    a.inst_id        = c.inst_id
and a.paddr          = c.addr
and a.inst_id = &&inst_id
and c.spid = &&server_pid
order by sid, serial#;
