column sql_text format a100   heading 'SQL Text';

--select substr(a.username, 1,10) as username, a.sid, a.serial#, substr(machine,1,10) as machine, a.status, b.sql_text
select a.username, a.sid, a.serial#, a.status, a.sql_id, c.blocks, c.tablespace, b.sql_text
from v$session a, v$sqlarea b, v$sort_usage c
where a.sql_hash_value = b.hash_value(+)
  and a.serial# = c.session_num
order by a.sid, a.serial#;
