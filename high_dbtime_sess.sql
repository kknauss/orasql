column inst_id   format 09        heading 'Inst';
column spid       format 9999999   heading 'OS PID'      ;
column username   format a22       heading 'Username'    ;
column module     format a42       heading 'Module'      ;
column cpu_pct    format 9990.00    heading 'CPU %'       ;
column cpu_sec    format 999990.00 heading 'CPU sec'     ;
column dbtime_sec format 999990.00 heading 'DB Time sec' ;


-- sessions with highest DB Time usage
SELECT s.inst_id, s.sid, s.serial#, s.status, p.spid, s.username, s.module, (st.value/100) dbtime_sec, (stcpu.value/100) cpu_sec, round(stcpu.value / st.value * 100,2) cpu_pct
FROM gv$sesstat st, v$statname sn, gv$session s, gv$sesstat stcpu, v$statname sncpu, gv$process p
WHERE sn.name = 'DB time'                    -- CPU
AND st.statistic# = sn.statistic#
AND st.inst_id = s.inst_id
AND st.sid = s.sid
AND sncpu.name = 'CPU used by this session'  -- CPU
AND stcpu.statistic# = sncpu.statistic#
AND stcpu.inst_id = st.inst_id
AND stcpu.sid = st.sid
AND s.inst_id = p.inst_id
AND s.paddr = p.addr
AND s.last_call_et < 1800                    -- active within last 1/2 hour
AND s.logon_time > (SYSDATE - 240/1440)      -- sessions logged on within 4 hours
AND st.value > 0
ORDER BY st.value/100 DESC;
