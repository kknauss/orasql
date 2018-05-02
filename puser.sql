column username format a13   heading 'Username';
column machine  format a22   heading 'Machine';
column status   format a10   heading 'Status';
column sql_text format a120  heading 'SQL Text';

column sid   format 99999
column degree   format 999
column req_degree   format 999
column iid  format 99


spool puser.log;

select * from gv$px_session order by qcsid, qcserial# nulls first;

select * from gv$px_process order by inst_id, server_name;

/*
select username, a.sid, a.serial#, machine, a.status, b.sql_text
from v$session a, v$sqlarea b, v$px_session c
where a.sql_hash_value = b.hash_value(+)
and a.saddr = c.saddr
order by sid, serial#; 
*/

spool off;
