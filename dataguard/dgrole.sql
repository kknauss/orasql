set null "<null>"

column DATABASE_ROLE                heading 'Database Role'
column DB_UNIQUE_NAME               heading 'Database|Unique Name'    format a12;
column PROTECTION_MODE              heading 'Protection Mode'
column PROTECTION_LEVEL             heading 'Protection Level'
column SWITCHOVER_STATUS            heading 'Switchover Status'
column CHECKPOINT_CHANGE#           heading 'Checkpoint|SCN'          format 99999999999;
column CURRENT_SCN                  heading 'Current|SCN'             format 99999999999;
column STANDBY_BECAME_PRIMARY_SCN   heading 'Standby to|Primary SCN'  format 99999999999;
column FS_FAILOVER_STATUS           heading 'FSFO|Status'             format a12;
column FS_FAILOVER_CURRENT_TARGET   heading 'FSFO|Curr Tgt'           format a10;
column FS_FAILOVER_THRESHOLD        heading 'FSFO|Thresh';
column FS_FAILOVER_OBSERVER_PRESENT heading 'FSFO|Obsrvr?';
column FS_FAILOVER_OBSERVER_HOST    heading 'FSFO|Obsrv Host'         format a10;

SELECT
	DATABASE_ROLE,
	DB_UNIQUE_NAME,
	PROTECTION_MODE,
	PROTECTION_LEVEL,
	SWITCHOVER_STATUS,
	CHECKPOINT_CHANGE#,
	CURRENT_SCN,
	STANDBY_BECAME_PRIMARY_SCN,
	FS_FAILOVER_STATUS,
	FS_FAILOVER_CURRENT_TARGET,
	FS_FAILOVER_THRESHOLD,
	FS_FAILOVER_OBSERVER_PRESENT,
	FS_FAILOVER_OBSERVER_HOST
FROM
	V$DATABASE;
