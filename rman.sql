DEF nbrhrs = &1

SET FEEDBACK OFF;
SET LINESIZE 135
SET TERMOUT OFF;
	ALTER SESSION SET CURRENT_SCHEMA = BACKUP;
	ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/RR hh24:mi:ss';
	COLUMN NOW NEW_VALUE TODAY;
	SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') now FROM DUAL;
SET TERMOUT ON;



col NAME                format A12 heading "Database|Name"
col INPUT_TYPE          format A10 heading "Backup|Type"
col STATUS              format A22 heading "Status"
col START_TIME                     heading "Start Time"
col END_TIME                       heading "End Time"
col TIME_TAKEN_DISPLAY  format  A9 heading "Elapsed|Time" justify RIGHT;
col INPUT_SIZE          format A10 heading "Input|Size"   justify RIGHT;
col OUTPUT_SIZE         format A10 heading "Output|Size"  justify RIGHT;
col INCREMENTAL_LEVEL   format  A5 heading "Level"        justify RIGHT;
col NBR_CHANNELS        format  99 Heading "Chan-|nels"
col IS_PRODUCTION       format  A6 Heading "Produc-|tion?"
col ALERT               format  A5 Heading "Alert"
col STATUS_SORT         NOPRINT

BREAK ON NAME       skip 0;

TTITLE 'Oracle RMAN Backup Report|for|&TODAY||Backups Completed in Last &NBRHRS hrs';


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
        CASE IS_PRODUCTION WHEN 'Y' THEN CASE WHEN NVL(STATUS,'MISSING') IN ('MISSING','FAILED','RUNNING WITH ERRORS','COMPLETED WITH ERRORS') THEN LPAD('!',3) ELSE NULL END ELSE NULL END ALERT
FROM TODAYSBACKUPS TDY, RC_DATABASE DB
WHERE TDY.DB_NAME(+) = DB.NAME
AND NOT EXISTS (SELECT 1 FROM FSB_RC_DATABASE_EXCLUDE X WHERE X.NAME = DB.NAME)
ORDER BY DB.IS_PRODUCTION DESC, STATUS_SORT, DB.NAME, START_TIME DESC;



SET FEEDBACK ON;
TTITLE OFF;
