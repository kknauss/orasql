SELECT * FROM STREAMS_ADMIN.CUSTOM_APPLY_LOG
WHERE ERROR_MSG_TYPE <> 'Info'
--WHERE ERROR_MSG_TYPE IN ('Fatalerror','Error')
--WHERE ERROR_MSG_TYPE = 'Fatalerror'
ORDER BY ERROR_TS DESC;

SELECT * FROM DBA_TABLES WHERE OWNER = 'STREAMS_ADMIN';

SELECT LS.* FROM STREAMS_ADMIN.LOAD_STATS LS ORDER BY START_TIME DESC, END_TIME DESC;

SELECT OWNER, OBJECT_TYPE, STATUS, COUNT(*)
FROM DBA_OBJECTS
WHERE OWNER = 'BRAVURA'
GROUP BY  OWNER, OBJECT_TYPE, STATUS
ORDER BY  OWNER, OBJECT_TYPE, STATUS ;
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';
SELECT OWNER, TABLE_NAME, LAST_ANALYZED FROM DBA_TABLES WHERE OWNER = 'BRAVURA' ORDER BY last_analyzed desc;  --TABLE_NAME;
--==============================================================================
  SELECT START_TIME , STATUS, 'impdp knauss_dba/mad31ndetroit DIRECTORY=DATA_PUMP_DIR DUMPFILE=BRAVURA.20130731_2100.dmp TABLES=BRAVURA.'||TABLE_NAME||' SQLFILE=BRAVURA.'||TABLE_NAME||'.sql'
    FROM STREAMS_ADMIN.LOAD_STATS
   WHERE OPERATION = 'TABLE_INSTANTIATE'
     AND START_TIME > TO_DATE('08/01/2013 23:08:53', 'mm/dd/yyyy hh24:mi:ss')
--   AND START_TIME > TO_DATE('08/01/2013 21:44:54', 'mm/dd/yyyy hh24:mi:ss') AND START_TIME <= TO_DATE('08/01/2013 23:08:53', 'mm/dd/yyyy hh24:mi:ss')
--   AND START_TIME > TO_DATE('08/01/2013 17:26:00', 'mm/dd/yyyy hh24:mi:ss') AND START_TIME <= TO_DATE('08/01/2013 21:44:54', 'mm/dd/yyyy hh24:mi:ss')
--   AND START_TIME > TO_DATE('08/01/2013 14:50:00', 'mm/dd/yyyy hh24:mi:ss') AND START_TIME <= TO_DATE('08/01/2013 17:26:00', 'mm/dd/yyyy hh24:mi:ss')
--   AND START_TIME > TO_DATE('08/01/2013 13:17:00', 'mm/dd/yyyy hh24:mi:ss') AND START_TIME <= TO_DATE('08/01/2013 14:50:00', 'mm/dd/yyyy hh24:mi:ss')
--   AND START_TIME > TO_DATE('08/01/2013 06:00:00', 'mm/dd/yyyy hh24:mi:ss') AND START_TIME <= TO_DATE('08/01/2013 13:17:00', 'mm/dd/yyyy hh24:mi:ss')
--   AND START_TIME > SYSDATE - 1                                             AND START_TIME <= TO_DATE('08/01/2013 06:00:00', 'mm/dd/yyyy hh24:mi:ss')
ORDER BY START_TIME DESC;

--==============================================================================
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';

SELECT A.*,
             TO_CHAR(FLOOR(    ((END_TIME-START_TIME) * (24*60*60))/(60*60))            ,'0999')  ||':'||
        TRIM(TO_CHAR(FLOOR(MOD(((END_TIME-START_TIME) * (24*60*60)),(60*60))/60)          ,'09')) ||':'||
        TRIM(TO_CHAR(      MOD(((END_TIME-START_TIME) * (24*60*60)),(60))                 ,'09')) ELAPSED
FROM STREAMS_ADMIN.LOAD_STATS a
WHERE EXISTS (
                SELECT 1
                FROM STREAMS_ADMIN.LOAD_STATS B
                WHERE B.STATUS = 'STARTED'
                AND B.TABLE_NAME = A.TABLE_NAME
                AND B.OPERATION = A.OPERATION
              )
ORDER BY A.TABLE_NAME, A.START_TIME DESC, A.END_TIME DESC;
--==============================================================================
SELECT COUNT(*) FROM STREAMS_ADMIN.LOAD_STATS WHERE START_TIME > SYSDATE -1 AND OPERATION = 'COPY_DATA' AND STATUS = 'STARTED';
SELECT COUNT(*) FROM STREAMS_ADMIN.LOAD_STATS WHERE START_TIME > SYSDATE -1 AND OPERATION = 'COPY_DATA' AND STATUS = 'COMPLETED';
SELECT COUNT(*) FROM STREAMS_ADMIN.MORTRAC_DW_REPLICATED_TABLE;
--==============================================================================
SELECT * FROM STREAMS_ADMIN.LOAD_STATS WHERE START_TIME > SYSDATE -1 AND OPERATION = 'COPY_DATA' ORDER BY TABLE_NAME;
SELECT * FROM STREAMS_ADMIN.LOAD_STATS WHERE OPERATION = 'COPY_DATA' and TABLE_NAME in ('LIABILITY','BORR_LIAB') ORDER BY START_TIME DESC, END_TIME DESC;
SELECT * FROM STREAMS_ADMIN.LOAD_STATS WHERE TABLE_NAME LIKE 'BORR_RE%' ORDER BY START_TIME DESC;
SELECT * FROM STREAMS_ADMIN.CURR_LOCKS; 
SELECT * FROM STREAMS_ADMIN.MORTRAC_DW_REPLICATED_TABLE order by table_name;
SELECT * FROM DBA_STREAMS_TABLE_RULES;
SELECT * FROM DBA_STREAMS_SCHEMA_RULES;

--==============================================================================
--These are the tables remaining; and historically how long stuff took
--==============================================================================
WITH B AS
(
  SELECT TABLE_NAME FROM STREAMS_ADMIN.MORTRAC_DW_REPLICATED_TABLE
  MINUS
  SELECT TABLE_NAME FROM STREAMS_ADMIN.LOAD_STATS WHERE START_TIME > SYSDATE -1.5 AND OPERATION = 'TABLE_INSTANTIATE' 
)
SELECT TABLE_NAME, OPERATION, STATUS,
             TO_CHAR(FLOOR(    ((END_TIME-START_TIME) * (24*60*60))/(60*60))            ,'0999')  ||':'||
        TRIM(TO_CHAR(FLOOR(MOD(((END_TIME-START_TIME) * (24*60*60)),(60*60))/60)          ,'09')) ||':'||
        TRIM(TO_CHAR(      MOD(((END_TIME-START_TIME) * (24*60*60)),(60))                 ,'09')) ELAPSED,
        START_TIME, END_TIME, ROW_COUNT, ERRORMSG
FROM STREAMS_ADMIN.LOAD_STATS A
WHERE A.OPERATION = 'COPY_DATA'
AND EXISTS (
                SELECT 1
                FROM B
                WHERE B.TABLE_NAME = A.TABLE_NAME    
            )
ORDER BY A.TABLE_NAME, A.START_TIME DESC, A.END_TIME DESC;



SELECT s.SUBSCRIBER_NAME,
       q.QUEUE_SCHEMA,
       q.QUEUE_NAME,
       s.LAST_DEQUEUED_SEQ,
       s.NUM_MSGS,
       S.TOTAL_SPILLED_MSG
FROM GV$BUFFERED_QUEUES q, GV$BUFFERED_SUBSCRIBERS s, DBA_APPLY a
WHERE q.QUEUE_ID = s.QUEUE_ID AND
      s.SUBSCRIBER_ADDRESS IS NULL AND
      S.SUBSCRIBER_NAME = A.APPLY_NAME;

ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';

SELECT APPLIED_MESSAGE_NUMBER-OLDEST_MESSAGE_NUMBER x, AP.* FROM DBA_APPLY_PROGRESS AP;

SELECT * FROM GV$BUFFERED_QUEUES;

SELECT 
        INST_ID,
        QUEUE_NAME, 
        STARTUP_TIME,
        SYSTIMESTAMP - OLDEST_MSG_ENQTM,
        OLDEST_MSG_ENQTM,   --Enqueue time of the oldest message
        LAST_ENQUEUE_TIME,  --Last message enqueue time
        LAST_DEQUEUE_TIME   --Last message dequeue time
FROM GV$BUFFERED_QUEUES;

alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';
select * from dba_apply_progress;