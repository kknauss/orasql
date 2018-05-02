select substr(a.username, 1,10) as username,
a.sid, a.serial#, substr(machine,1,10) as machine, a.status,
b.sql_text
from v$session a, v$sqltext b
where a.sql_hash_value = b.hash_value
order by sid, serial#, piece;