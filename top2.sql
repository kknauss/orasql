column inst_id         format  99 heading 'In|st';
column username        format a25 heading 'Username';
column machine         format a36 heading 'Machine';
column event           format a48 heading 'Wait Event';
column wait_time       heading 'Wait|Time';
column wait_class      format a14 heading 'Wait|Class';
column seconds_in_wait heading 'Seconds|In Wait';
column last_call_et    format  9999999 heading 'Last|Call|Elap(s)';
column sid             format  999999; 
column serial#         format  999999 heading 'Serial#';
column status          format  a8 heading 'Status';

  SELECT   inst_id,
           username,
           machine,
           last_call_et,
           sid,
           serial#, sql_id, status,
           event, wait_class, wait_time, seconds_in_wait, sql_child_number, SQL_HASH_VALUE
    FROM   gv$session
--WHERE wait_class != 'Idle'
WHERE status = 'ACTIVE'
 AND username = 'DM_OBIEE_APPID'
--  AND username <> 'SYS'
ORDER BY   last_call_et DESC; 

