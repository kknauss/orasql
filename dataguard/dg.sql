set linesize 220;
column name format a28;
column value         format a92;
column display_value format a92;

select log_mode, force_logging from v$database;

select group#, thread#, bytes/1048576 SizeMB, members from v$log;
select * from v$standby_log;

select
	name,
	value,
	display_value,
	case when (nvl(value,'null')=nvl(display_value,'null')) then ' ' else 'Y' end diff
from
	v$parameter
where
	upper(name) in (
 'DB_NAME'
,'DB_UNIQUE_NAME'
,'FAL_CLIENT'
,'FAL_SERVER'
,'LOG_ARCHIVE_CONFIG'
,'LOG_ARCHIVE_DEST'
,'LOG_ARCHIVE_DEST_1'
,'LOG_ARCHIVE_DEST_2'
,'LOG_ARCHIVE_DEST_STATE_1'
,'LOG_ARCHIVE_DEST_STATE_2'
,'LOG_ARCHIVE_FORMAT'
,'LOG_ARCHIVE_MAX_PROCESSES'
,'SPFILE'
,'STANDBY_FILE_MANAGEMENT'
,'STANDBY_ARCHIVE_DEST'
,'DB_FILE_NAME_CONVERT'
,'LOG_FILE_NAME_CONVERT'
,'REMOTE_LOGIN_PASSWORDFILE'
)
order by name;

select OPEN_MODE
,PROTECTION_MODE
,PROTECTION_LEVEL
,DATABASE_ROLE
,SWITCHOVER_STATUS
,DATAGUARD_BROKER
,GUARD_STATUS from v$database;

SELECT DEST_ID, SEQUENCE#, FIRST_TIME, NEXT_TIME, COMPLETION_TIME, APPLIED FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;
