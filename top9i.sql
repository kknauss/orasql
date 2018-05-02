set verify off;

column spid                  heading 'Server|PID';
column server                heading 'Server|Type';
column last_call_et          heading 'Last Call|Elap(sec)';
column event    format a30   heading 'Wait Event';
column machine  format a22   heading 'Machine';
column program  format a22   heading 'Program';
column username format a13   heading 'Username';
column status   format  a8   heading 'Status';
column sql_text format a120  heading 'SQL Text';
column machine format a22;




/*
  SELECT   
           s.username,
           s.machine,
           s.last_call_et,
           s.sid,
           s.serial#,
	b.sql_text
    FROM   v$session s, v$sqlarea b
   WHERE       s.username IS NOT NULL
           AND s.username <> 'SYS'
           AND s.status = 'ACTIVE'
and s.sql_hash_value = b.hash_value(+)
ORDER BY   s.last_call_et DESC; 
*/

  SELECT   
           s.username,
           s.machine,
		p.spid,
           s.last_call_et,
           s.sid,
           s.serial#,
	b.sql_text
    FROM   v$session s, v$sqltext b, v$process p
   WHERE       s.username IS NOT NULL
           AND s.username <> 'SYS'
           AND s.status = 'ACTIVE'
and s.sql_hash_value = b.hash_value(+)
and s.paddr          = p.addr
ORDER BY   s.last_call_et DESC, s.sid, b.piece;
