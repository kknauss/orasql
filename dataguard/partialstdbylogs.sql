prompt =========================
prompt Use this value from primary
prompt =========================

SELECT RESETLOGS_CHANGE#
FROM V$DATABASE_INCARNATION
WHERE STATUS = 'CURRENT'; 


prompt =========================
prompt On the target physical standby database, identify any active standby redo logs (SRLs)
prompt If there are any active SRLs, make sure they do note have a thread#/sequence# less than that returned by the next query
prompt =========================

SELECT GROUP#, THREAD#, SEQUENCE#
FROM V$STANDBY_LOG
WHERE STATUS = 'ACTIVE'
ORDER BY THREAD#, SEQUENCE#;


prompt =========================
prompt On the target physical standby database, identify maximum applied sequence number(s).
prompt =========================

SELECT THREAD#, MAX(SEQUENCE#)
FROM V$LOG_HISTORY
WHERE RESETLOGS_CHANGE# = &prmy_rstlgs_chgnbr
GROUP BY THREAD#;

prompt =========================
prompt If there are (avoid bug 7159505) you need to clear them on the standby:
prompt
prompt SQL> RECOVER MANAGED STANDBY DATABASE CANCEL
prompt SQL> ALTER DATABASE CLEAR LOGFILE GROUP <group number of standby redo log>;
prompt =========================
