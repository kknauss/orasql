ALTER SESSION SET CURRENT_SCHEMA = BACKUP;
ALTER SESSION SET CURRENT_SCHEMA = RMAN_PRD;
ALTER SESSION SET CURRENT_SCHEMA = RMAN_NP;
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy';

--select * from x  where db_name = UPPER('&dname') order by start_time desc;

WITH X AS (
              SELECT 
              DB_NAME, OUTPUT_DEVICE_TYPE, INPUT_TYPE, 
              (SELECT MAX(INCREMENTAL_LEVEL) FROM RC_BACKUP_SET_DETAILS x where x.SESSION_KEY = d.SESSION_KEY and x.SESSION_RECID = d.SESSION_RECID AND x.SESSION_STAMP = d.SESSION_STAMP) INCREMENTAL_LEVEL,
              START_TIME, END_TIME, TIME_TAKEN_DISPLAY ELAPSED, STATUS, INPUT_BYTES_DISPLAY INPUT_SIZE, OUTPUT_BYTES_DISPLAY OUTPUT_SIZE
              FROM RC_RMAN_BACKUP_JOB_DETAILS d
              WHERE INPUT_TYPE IN ('DB INCR','DB FULL')
              AND (END_TIME > SYSDATE - 30)
)
--select * from x  where db_name = UPPER('&dname') order by start_time desc;
SELECT DB_NAME, SYSDATE AS_OF,
                                     to_char(floor(    ((avg(end_time-start_time))*24*60*60) /(60*60))     ,'09')  ||':'||
                                trim(to_char(floor(mod(((avg(end_time-start_time))*24*60*60) ,(60*60))/60) ,'09')) ||':'||
                                trim(to_char(      mod(((avg(end_time-start_time))*24*60*60) ,(60))        ,'09')) AVG_ELAPSED
FROM X
WHERE INPUT_TYPE = 'DB INCR'
AND INCREMENTAL_LEVEL = 0
AND STATUS = 'COMPLETED'
GROUP BY DB_NAME
ORDER BY DB_NAME;
--==============================================================================
alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';
WITH X AS (
              SELECT 
              DB_NAME, OUTPUT_DEVICE_TYPE, INPUT_TYPE, 
              START_TIME, END_TIME, TIME_TAKEN_DISPLAY ELAPSED, STATUS, INPUT_BYTES_DISPLAY INPUT_SIZE, OUTPUT_BYTES_DISPLAY OUTPUT_SIZE
              FROM RC_RMAN_BACKUP_JOB_DETAILS d
              WHERE INPUT_TYPE = 'ARCHIVELOG'
              AND (END_TIME > SYSDATE - 30)
)
select * from x  where db_name = UPPER('&dname') order by start_time desc;

--==============================================================================
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';
ALTER SESSION SET CURRENT_SCHEMA = BACKUP;
WITH TODAYSBACKUPS AS (
        SELECT BJD.*
        ,(SELECT MAX(INCREMENTAL_LEVEL) FROM RC_BACKUP_SET_DETAILS where SESSION_KEY = BJD.SESSION_KEY and SESSION_RECID = BJD.SESSION_RECID AND SESSION_STAMP = BJD.SESSION_STAMP) INCREMENTAL_LEVEL
        ,(SELECT count(*) FROM RC_RMAN_OUTPUT where SESSION_KEY  = BJD.SESSION_KEY and output like 'allocated channel: ORA_SBT_TAPE%') NBR_CHANNELS
        FROM RC_RMAN_BACKUP_JOB_DETAILS BJD
        WHERE BJD.INPUT_TYPE IN ('DB INCR','DB FULL')
        AND (BJD.END_TIME > SYSDATE - &nbrhrs/24 OR BJD.STATUS = 'RUNNING')
)
SELECT  DB.NAME,
        DB.IS_PRODUCTION,
        CASE INPUT_TYPE WHEN 'DB INCR' THEN INPUT_TYPE||' L'||NVL(TO_CHAR(INCREMENTAL_LEVEL),'-') ELSE INPUT_TYPE END INPUT_TYPE,
        CASE NBR_CHANNELS WHEN 0 THEN NULL ELSE NBR_CHANNELS END NBR_CHANNELS,
        NVL(STATUS,'MISSING') STATUS,
        CASE NVL(STATUS,'MISSING') WHEN 'MISSING' THEN 99 ELSE 1 END STATUS_SORT,
        START_TIME,
        CASE STATUS WHEN 'RUNNING' THEN NULL ELSE END_TIME END END_TIME,
        LPAD(
                CASE STATUS WHEN 'RUNNING'
                THEN
                                     to_char(floor(    ((sysdate-start_time)*24*60*60) /(60*60))     ,'09')  ||':'||
                                trim(to_char(floor(mod(((sysdate-start_time)*24*60*60) ,(60*60))/60) ,'09')) ||':'||
                                trim(to_char(      mod(((sysdate-start_time)*24*60*60) ,(60))        ,'09'))
                ELSE TIME_TAKEN_DISPLAY
                END, 9
        ) TIME_TAKEN_DISPLAY,
        LPAD(INPUT_BYTES_DISPLAY, 10) INPUT_SIZE,
        LPAD(OUTPUT_BYTES_DISPLAY,10) OUTPUT_SIZE,
        CASE IS_PRODUCTION WHEN 'Y' THEN CASE WHEN NVL(STATUS,'MISSING') IN ('MISSING','FAILED','RUNNING WITH ERRORS','COMPLETED WITH ERRORS') THEN '!' ELSE NULL END ELSE NULL END "Alert"
FROM TODAYSBACKUPS TDY, RC_DATABASE DB
WHERE TDY.DB_NAME(+) = DB.NAME;
ORDER BY DB.IS_PRODUCTION DESC, STATUS_SORT, DB.NAME, START_TIME DESC;


select scn_to_timestamp(275834144777) from dual;

--==============================================================================
SELECT * FROM RC_RMAN_BACKUP_JOB_DETAILS WHERE DB_NAME = UPPER('&dbname') ORDER BY START_TIME DESC;
SELECT * FROM RC_RMAN_BACKUP_SUBJOB_DETAILS WHERE DB_NAME = UPPER('&dbname') ORDER BY START_TIME DESC;
SELECT * FROM RC_RMAN_BACKUP_JOB_DETAILS WHERE STATUS = 'RUNNING WITH ERRORS';
SELECT * FROM RC_BACKUP_SET_DETAILS WHERE SESSION_KEY = 303099 AND SESSION_RECID = 34 AND SESSION_STAMP = 847377004 ORDER BY RECID;
SELECT * FROM RC_BACKUP_SET_DETAILS where db_name = 'DTMS';
SELECT * FROM RC_BACKUP_SET;
SELECT * FROM RC_RMAN_OUTPUT where SESSION_KEY  = 173573 and output like 'allocated channel: ORA_SBT_TAPE%';
SELECT * FROM RC_RMAN_OUTPUT where SESSION_KEY  = (SELECT session_key FROM RC_RMAN_BACKUP_JOB_DETAILS WHERE STATUS = 'RUNNING WITH ERRORS') order by recid;
SELECT * FROM RC_RMAN_OUTPUT where SESSION_KEY  = 210201 order by recid;

/* *****************************************************************************
 * *****************************************************************************
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';
SELECT DB_NAME, INPUT_TYPE, END_TIME, OUTPUT_BYTES_DISPLAY, STATUS FROM RC_RMAN_BACKUP_JOB_DETAILS WHERE DB_NAME  = 'BRAV' AND INPUT_TYPE IN ('DB INCR','DB FULL') ORDER BY END_TIME DESC NULLS LAST;
SELECT DB_NAME, INPUT_TYPE, END_TIME, OUTPUT_BYTES_DISPLAY, STATUS FROM RC_RMAN_BACKUP_JOB_DETAILS WHERE DB_NAME  = 'BRAV' ORDER BY END_TIME DESC NULLS LAST;
SELECT * FROM RC_RMAN_BACKUP_JOB_DETAILS WHERE DB_NAME  = 'FIN' ORDER BY END_TIME DESC NULLS LAST;

/* *****************************************************************************
 * *****************************************************************************
*/
--What databases are in this rman catalog...
SELECT * FROM RC_DATABASE ORDER BY NAME ;

select user from dual;


ALTER SESSION SET CURRENT_SCHEMA = RMAN_PRD;
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';
SELECT SYSDATE -70 FROM DUAL;
SELECT SYSDATE -45 FROM DUAL;
SELECT *                FROM RC_BACKUP_SET   WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') ORDER BY BS_KEY DESC;
SELECT STATUS, COUNT(*) FROM RC_BACKUP_SET   WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') GROUP BY STATUS;
SELECT MIN(START_TIME), MAX(START_TIME)
                        FROM RC_BACKUP_SET   WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') and STATUS = 'O';
SELECT COUNT(*)         FROM RC_BACKUP_SET   WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') AND START_TIME < SYSDATE -45;

SELECT MEDIA, STATUS, COUNT(*), MIN(START_TIME), MAX(START_TIME) FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') GROUP BY MEDIA, STATUS ORDER BY MIN(START_TIME);
SELECT (49603-44518) RECORDS_LEFT, (45122-44518) records_left_till_nojack, ROUND(((49603-44518)* 1.0)/60/60,2) ESTIMATE FROM DUAL;
SELECT *                FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') AND RECID = 66087;
SELECT *                FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') AND RECID = 67854;
SELECT *                FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') AND BP_KEY = 3560865;
SELECT STATUS, COUNT(*) FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') GROUP BY STATUS;
SELECT TAG, STATUS, COUNT(*) FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') AND STATUS = 'X' GROUP BY TAG, STATUS;

SELECT media, status, count(*), min(start_time), max(start_time) FROM RC_BACKUP_PIECE WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV') group by media, status order by min(start_time);


SELECT *
FROM RC_ARCHIVED_LOG
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'ERCM')
ORDER BY AL_KEY DESC;

/*
A	2763
X	29029
A	2785
X	18420
A	2791
X	15461
*/
SELECT STATUS, COUNT(*)
FROM RC_ARCHIVED_LOG
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV')
GROUP BY STATUS
ORDER BY STATUS;

select sysdate, sysdate-12 from dual;
alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';
select * from RC_ARCHIVED_LOG where name = '/archive/BRAV/ARC53615794332033.0004' and DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'BRAV');
select * from RC_ARCHIVED_LOG where  DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'ERCM') order by recid desc;

--For a given backup with tag, what is the oldest checkpoint_time.  This is useful for determining the "set until" 
--scn/time for a duplication where you want to make sure you grab the specified backup while minimizing the number 
--of logs that need to be applied.
SELECT MAX(CHECKPOINT_TIME)
FROM RC_BACKUP_DATAFILE
WHERE BS_KEY IN ( SELECT DISTINCT BS_KEY
                  FROM RC_BACKUP_PIECE
                  WHERE DB_KEY = 1
                  AND STATUS = 'A'
                  AND TAG = 'TAG20060525T230023' )
ORDER BY FILE#;



SELECT *
FROM RC_BACKUP_PIECE
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
AND STATUS = 'A'
ORDER BY COMPLETION_TIME ;
 
SELECT 'VALIDATE BACKUPSET '||BS_KEY ||' ;'
FROM RC_BACKUP_PIECE 
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
--D BS_key BETWEEN m AND n
--D handle LIKE '%.lvl0bkup'
ORDER BY BS_KEY ; 
 
 --bs_key is the backupset number you'd use when e.g.
 -- run {... validate backupset nnnn....}
SELECT *
FROM RC_BACKUP_SET
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
--D STATUS = 'A'
ORDER BY START_TIME ;
 

--Find the scn (checkpoint_change#) of the backup you wish to restore.
--Then, query against rc_log_history to find out what log you'll need (minimum)
--to complete the restore/duplicate.  You won't need to worry if you used rman
--to backup the logs.
SELECT *
FROM RC_LOG_HISTORY
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
--D FIRST_CHANGE# <= 7072171845
--D NEXT_CHANGE#   > 7072171845
ORDER BY FIRST_CHANGE#;
 
SELECT *
FROM RC_BACKUP_REDOLOG
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
ORDER BY FIRST_CHANGE#;
 
 --Let's grab all logfiles from the day and determine which ones we'll need.... 
SELECT thread#, SEQUENCE#, first_time, first_change#, next_change#  FROM rc_log_history
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
AND TO_CHAR(first_time, 'mm/dd/yyyy hh24:mi') >= '05/31/2006 00:00'
AND TO_CHAR(first_time, 'mm/dd/yyyy hh24:mi') <= '05/31/2006 23:59' 
ORDER BY first_change#;
 
--If hot and cold backups go to different destinations (TSM Filespaces), you may need
--to make the backups in the "other" location unavailable so rman does not try to 
--retrieve backups from there.  Even if you specify an SCN of a cold backup, rman 
--typically will try to use a subsequent hot backup...
SELECT 'change backup piece ''' ||handle||''' UNAVAILABLE; '
FROM rc_backup_piece
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
AND LOWER(handle) LIKE '%hotbkup%' 
AND status = 'A'
ORDER BY completion_time ;
 
--View the number of [un]available backup pieces...
SELECT STATUS, COUNT(*)
FROM RC_BACKUP_PIECE
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
GROUP BY STATUS ;
 
SELECT A.DB_KEY, A.DB_ID, A.BS_KEY, A.HANDLE, A.COMPLETION_TIME, B.CHECKPOINT_TIME, B.CHECKPOINT_CHANGE#, B.FILE#
FROM RC_BACKUP_PIECE A, RC_BACKUP_DATAFILE B
WHERE A.DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
AND A.BS_KEY = B.BS_KEY
ORDER BY A.COMPLETION_TIME ;
 
--View one detail-line for each backup piece for this database...
SELECT A.DB_KEY, MIN(B.CHECKPOINT_CHANGE#), MAX(B.CHECKPOINT_CHANGE#), A.HANDLE, A.COMPLETION_TIME, A.DB_ID, A.BS_KEY, MAX(B.CHECKPOINT_TIME), count(1) DATAFILES_IN_PIECE
FROM RC_BACKUP_PIECE A, RC_BACKUP_DATAFILE B
WHERE A.DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
AND A.BS_KEY = B.BS_KEY
GROUP BY A.DB_KEY, A.DB_ID, A.BS_KEY, A.HANDLE, A.COMPLETION_TIME
ORDER BY A.DB_KEY, A.DB_ID, A.BS_KEY, A.HANDLE, A.COMPLETION_TIME ;
 
SELECT A.FIRST_CHANGE#, A.NEXT_CHANGE#, A.* FROM RC_ARCHIVED_LOG A
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW')
--D FIRST_CHANGE# <= 724722260892
--D NEXT_CHANGE#  >= 724722260892 
;

--What stored scripts exist for this database...
SELECT *
FROM RC_STORED_SCRIPT
WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'DDW');

--What stored scripts and their body exist for this database...
SELECT DB_NAME, SCRIPT_NAME, TEXT
FROM RC_STORED_SCRIPT_LINE NATURAL JOIN RC_STORED_SCRIPT B
ORDER BY DB_NAME, SCRIPT_NAME, LINE ;

SELECT BP.DEVICE_TYPE, DB.NAME, COUNT(*)
FROM RC_BACKUP_PIECE BP, RC_DATABASE DB
WHERE BP.DB_KEY  = DB.DB_KEY
GROUP BY BP.DEVICE_TYPE, DB.NAME;


select 'SELECT * FROM '||VIEW_NAME||';' FROM DBA_VIEWS WHERE OWNER = 'RMAN_NP' and view_name like 'RC\_%' escape '\' order by view_name;

alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';

SELECT * FROM RC_ARCHIVED_LOG WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'FS90PRD') and STATUS = 'X' order by first_time desc;

SELECT * FROM RC_ARCHIVED_LOG WHERE DB_KEY = (SELECT DB_KEY FROM RC_DATABASE WHERE NAME = 'ITDW') and name = '/archive/ITDW/ARC81728506011407.0001' order by first_time desc;

SELECT * FROM RC_BACKUP_ARCHIVELOG_SUMMARY;
SELECT * FROM RC_BACKUP_CONTROLFILE;
SELECT * FROM RC_BACKUP_CONTROLFILE_DETAILS;
SELECT * FROM RC_BACKUP_CONTROLFILE_SUMMARY;
SELECT * FROM RC_BACKUP_COPY_DETAILS;
SELECT * FROM RC_BACKUP_COPY_SUMMARY;
SELECT * FROM RC_BACKUP_CORRUPTION;
SELECT * FROM RC_BACKUP_DATAFILE;
SELECT * FROM RC_BACKUP_DATAFILE_DETAILS;
SELECT * FROM RC_BACKUP_DATAFILE_SUMMARY;
SELECT * FROM RC_BACKUP_FILES;
SELECT * FROM RC_BACKUP_PIECE;
SELECT * FROM RC_BACKUP_PIECE_DETAILS;
SELECT * FROM RC_BACKUP_REDOLOG;
SELECT * FROM RC_BACKUP_SET;
SELECT * FROM RC_BACKUP_SET_DETAILS;
SELECT * FROM RC_BACKUP_SET_SUMMARY;
SELECT * FROM RC_BACKUP_SPFILE;
SELECT * FROM RC_BACKUP_SPFILE_DETAILS;
SELECT * FROM RC_BACKUP_SPFILE_SUMMARY;
SELECT * FROM RC_CHECKPOINT;
SELECT * FROM RC_CONTROLFILE_COPY;
SELECT * FROM RC_COPY_CORRUPTION;
SELECT * FROM RC_DATABASE;
SELECT * FROM RC_DATABASE_BLOCK_CORRUPTION;
SELECT * FROM RC_DATABASE_INCARNATION;
SELECT * FROM RC_DATAFILE;
SELECT * FROM RC_DATAFILE_COPY;
SELECT * FROM RC_LOG_HISTORY;
SELECT * FROM RC_OFFLINE_RANGE;
SELECT * FROM RC_PROXY_ARCHIVEDLOG;
SELECT * FROM RC_PROXY_ARCHIVELOG_DETAILS;
SELECT * FROM RC_PROXY_ARCHIVELOG_SUMMARY;
SELECT * FROM RC_PROXY_CONTROLFILE;
SELECT * FROM RC_PROXY_COPY_DETAILS;
SELECT * FROM RC_PROXY_COPY_SUMMARY;
SELECT * FROM RC_PROXY_DATAFILE;
SELECT * FROM RC_REDO_LOG;
SELECT * FROM RC_REDO_THREAD;
SELECT * FROM RC_RESTORE_POINT;
SELECT * FROM RC_RESYNC;

SELECT * FROM RC_BACKUP_SET_DETAILS where session_key = 112878;
SELECT * FROM RC_RMAN_BACKUP_SUBJOB_DETAILS where db_name = 'ITDW';
SELECT * FROM RC_RMAN_BACKUP_TYPE;
SELECT * FROM RC_RMAN_CONFIGURATION;
SELECT * FROM RC_RMAN_OUTPUT;
SELECT * FROM RC_RMAN_STATUS where db_name = 'ITDW';
SELECT * FROM RC_SITE;
SELECT * FROM RC_STORED_SCRIPT;
SELECT * FROM RC_STORED_SCRIPT_LINE;
SELECT * FROM RC_TABLESPACE;
SELECT * FROM RC_TEMPFILE;
SELECT * FROM RC_UNUSABLE_BACKUPFILE_DETAILS;

--==============================================================================
--==============================================================================
--==============================================================================
--==============================================================================

/*
 * V$BACKUP_ASYNC_IO displays performance information about ongoing and recently completed RMAN backups and restores. 
 * For each backup, it contains one row for each input datafile, one row for the aggregate total performance of all 
 * datafiles, and one row for the output backup piece. This data is not stored persistently, and is not preserved when 
 * the instance is re-started.
*/
select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec, a.* 
from v$backup_async_io a
order by set_count;

/*
 * V$BACKUP_SYNC_IO displays performance information about ongoing and recently completed RMAN backups and restores. 
 * For each backup, it contains one row for each input datafile, one row for the aggregate total performance of all 
 * datafiles, and one row for the output backup piece. This data is not stored persistently, and is not preserved when 
 * the instance is re-started.
*/
select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec, a.* 
from v$backup_sync_io a 
order by set_count;


--
--
--select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec, b.*, a.*
select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec,a.effective_bytes_per_second, a.device_type, b.handle, a.status, b.status, b.start_time, b.completion_time
from v$backup_async_io a, v$backup_piece b
where a.set_stamp = b.set_stamp
and a.set_count = b.set_count
--and a.filename like '%.lvl%bkup'
--and a.filename like '%.archbkup'
--and to_date(substr(b.tag,4,8),'yyyymmdd') > sysdate - 1
order by a.set_count;


select 'SELECT * FROM '||OBJECT_NAME||';' from dba_objects where object_name like 'V$BACKUP%' ORDER BY OBJECT_NAME;

SELECT * FROM V$BACKUP;
SELECT * FROM V$BACKUP_ARCHIVELOG_DETAILS;
SELECT * FROM V$BACKUP_ARCHIVELOG_SUMMARY;
SELECT * FROM V$BACKUP_ASYNC_IO;
SELECT * FROM V$BACKUP_CONTROLFILE_DETAILS;
SELECT * FROM V$BACKUP_CONTROLFILE_SUMMARY;
SELECT * FROM V$BACKUP_COPY_DETAILS;
SELECT * FROM V$BACKUP_COPY_SUMMARY;
SELECT * FROM V$BACKUP_CORRUPTION;
SELECT * FROM V$BACKUP_DATAFILE ORDER BY CREATION_TIME DESC;
SELECT * FROM V$BACKUP_DATAFILE_DETAILS;
SELECT * FROM V$BACKUP_DATAFILE_SUMMARY;
SELECT * FROM V$BACKUP_DEVICE;
SELECT * FROM V$BACKUP_FILES;
SELECT * FROM V$BACKUP_PIECE;
SELECT * FROM V$BACKUP_PIECE_DETAILS;
SELECT * FROM V$BACKUP_REDOLOG;
SELECT * FROM V$BACKUP_SET;
SELECT * FROM V$BACKUP_SET_DETAILS;
SELECT * FROM V$BACKUP_SET_SUMMARY;
SELECT * FROM V$BACKUP_SPFILE;
SELECT * FROM V$BACKUP_SPFILE_DETAILS;
SELECT * FROM V$BACKUP_SPFILE_SUMMARY;
SELECT * FROM V$BACKUP_SYNC_IO;

