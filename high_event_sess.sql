column username format a32;
column module   format a48;
column "CPU sec" format 990.00;

-- sessions with the highest time for a certain wait
SELECT s.inst_id, s.sid, s.serial#, p.spid as "OS PID", s.username, s.module, se.time_waited
FROM gv$session_event se, gv$session s, gv$process p
WHERE se.event = '&event_name'
AND s.last_call_et < 1800                    -- active within last 1/2 hour
AND s.logon_time > (SYSDATE - 240/1440)      -- sessions logged on within 4 hours
AND se.inst_id = s.inst_id
AND se.sid = s.sid
AND s.inst_id = p.inst_id
AND s.paddr = p.addr
ORDER BY se.time_waited DESC;
