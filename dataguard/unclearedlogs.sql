prompt ============================================
prompt This is to be run on the STANDBY prior to
prompt switchover.  If the following query returns 
prompt any rows, the following ALTER DATABASE
prompt statement needs to be run for every GROUP#:
prompt 
prompt ALTER DATABASE CLEAR LOGFILE GROUP <GROUP#>;
prompt ============================================

SELECT DISTINCT L.GROUP#
FROM V$LOG L, V$LOGFILE LF
WHERE L.GROUP# = LF.GROUP#
AND L.STATUS NOT IN ('UNUSED','CLEARING','CLEARING_CURRENT');
