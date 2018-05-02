select substr(a.username, 1,10) as username,
a.sid, a.serial#, substr(machine,1,10) as machine, a.status,
b.sql_text
from v$session a, v$sqltext b
where a.sql_hash_value = b.hash_value and a.sid = 66
order by sid, serial#, piece
;

select username from dba_users order by username ;

desc v$session

desc v$statname

select * from v$timer 

select a.statistic#, name, value from v$sesstat a, v$statname b where a.statistic# = b.statistic# and sid = 66 and lower(name) like '%parse%' ;

select a.statistic#, name, value from v$sesstat a, v$statname b where a.statistic# = b.statistic# and sid = 66 and lower(name) like '%write%' ;

select a.statistic#, name, value from v$sesstat a, v$statname b where a.statistic# = b.statistic# and sid = 66 and lower(name) like '%redo%' ;

select a.statistic#, name, value from v$sesstat a, v$statname b where a.statistic# = b.statistic# and sid = 66  and a.statistic# = 9 ;

select a.statistic#, name, value from v$sesstat a, v$statname b where a.statistic# = b.statistic# and sid = 66  ; 

--select a.statistic#, name, to_char((sysdate-(hsecs - value)/(100*60*60*24)),'mm/dd/yyyy hh:mi:ss'), value
select a.statistic#, name, to_char((sysdate-(hsecs - value)/(100*60*60*24)),'mm/dd/yyyy hh:mi:ss'), value 
from v$sesstat a, v$statname b, v$timer
where a.statistic# = b.statistic# 
and sid = 66  
and a.statistic# = 13 ;

desc v$sqlarea

SELECT   sql_text, disk_reads, executions, disk_reads / DECODE (executions, 0, 1, executions) reads_per_exec
FROM     v$sqlarea a, v$session b
where a.address = b.sql_address
and b.sid = 66 ;

SELECT   sql_text, disk_reads, executions, disk_reads / DECODE (executions, 0, 1, executions) reads_per_exec
FROM     v$sqlarea
ORDER BY disk_reads; 
--ORDER BY reads_per_exec; 

SELECT   sql_text, buffer_gets, executions, buffer_gets / DECODE (executions, 0, 1, executions) gets_per_exec
FROM     v$sqlarea
ORDER BY buffer_gets;

SELECT   sql_text, buffer_gets, executions, buffer_gets / DECODE (executions, 0, 1, executions) gets_per_exec
FROM     v$sqlarea a, v$session b
where a.address = b.sql_address
and b.sid = 66 ;

SELECT  A.name, B.value
   FROM  v$statname A, v$sesstat B
 WHERE  B.statistic# IN (12, 37, 38, 39, 119, 123, 139, 140, 141)
     AND  B.sid = 66 
     AND  A.statistic# = B.statistic#;
	 
SELECT name || ' (instance-wide)', value
    FROM   v$sysstat
    WHERE  statistic# = 39
    UNION ALL
    SELECT 'sid = ' || TO_CHAR (sid), value
    FROM   v$sesstat
    WHERE  statistic# = 39;
	
--How many cursors can a session have?  How many will remain in cache?
select name,to_number(value) value from v$parameter where name in ('open_cursors','session_cached_cursors');

--How many cursors are opened per session?
	select b.sid, a.username, b.value open_cursors
      from v$session a,
           v$sesstat b,
           v$statname c
      where c.name in ('opened cursors current')
      and   b.statistic# = c.statistic#
      and   a.sid = b.sid 
      and   a.username is not null
      and   b.value >0
      order by 3 desc ;
	  
-- If 2 logically equivalient SQL's are returned they should be changed to be syntactically equivalent, then the optimizer doesn't re-parse each one each time...	  
select a.parsing_user_id,a.parse_calls,a.executions,b.sql_text||'<'
from v$sqlarea a, v$sqltext b
where a.parse_calls >= a.executions
and a.executions > 10
and a.parsing_user_id > 0
and a.address = b.address
and a.hash_value = b.hash_value
order by 1,2,3,a.address,a.hash_value,b.piece;

-- This might help find logically-equivalent queries. Look for queries that are identical up until the first (...
select count(1) cnt,substr(sql_text,1,instr(SQL_text,'(')) string
from v$sqlarea
group by substr(SQL_text,1,instr(SQL_text,'('))
order by 1;
