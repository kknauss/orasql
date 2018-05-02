prompt =========================
prompt Compare this from primary
prompt =========================

select thread#, sequence# from v$thread;


prompt =========================
prompt To this from standby
prompt =========================

SELECT THREAD#, MAX(SEQUENCE#)
FROM V$ARCHIVED_LOG
WHERE APPLIED = 'YES'
AND RESETLOGS_CHANGE# =	(
				SELECT RESETLOGS_CHANGE#
				FROM V$DATABASE_INCARNATION
				WHERE STATUS = 'CURRENT'
			)
GROUP BY THREAD#;
