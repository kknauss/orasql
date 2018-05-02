col status format a8;
--select user_name, status, osuser, machine, a.sql_text 
select user_name, status, osuser, machine, b.sid, b.serial#, count(*)
from v$session b, v$open_cursor a 
where a.sid = b.sid 
group by user_name, status, osuser, machine, b.sid, b.serial#
order by count(*);
