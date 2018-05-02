column inst_id   format 09        heading 'Inst';
column sid       format 9999999   heading 'SID';
column spid      format 9999999   heading 'OS PID';
column username  format a22       heading 'Username';
column module    format a42       heading 'Module';
column cpu_sec   format 999990.00 heading 'CPU sec';

-- sessions with highest CPU consumption
SELECT s.inst_id, s.sid, s.serial#, s.status, p.spid, s.username, s.module, (st.value/100) cpu_sec
FROM gv$sesstat st, v$statname sn, gv$session s, gv$process p
WHERE sn.name = 'CPU used by this session'   -- CPU
AND st.statistic# = sn.statistic#
AND st.inst_id = s.inst_id
AND st.sid = s.sid
AND s.inst_id = p.inst_id
AND s.paddr = p.addr
--and s.last_call_et < 1800                    -- active within last 1/2 hour
and s.logon_time > (SYSDATE - 240/1440)      -- sessions logged on within 4 hours
AND (st.value/100) > 0.00
ORDER BY st.value DESC;
