SELECT TOTAL_SIZE,AWR_FLUSH_EMERGENCY_COUNT FROM V$ASH_INFO;

ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS';

SELECT
        NAME,                                                                   --Name of the server
--      PADDR,                                                                  --Server's process address
        STATUS,                                                                 --Server status:
                                                                                    --EXEC - Executing SQL
                                                                                    --WAIT (ENQ) - Waiting for a lock
                                                                                    --WAIT (SEND) - Waiting to send data to user
                                                                                    --WAIT (COMMON) - Idle; waiting for a user request
                                                                                    --WAIT (RESET) - WAITING FOR A CIRCUIT TO RESET AFTER A BREAK
                                                                                    --QUIT - Terminating
        MESSAGES,                                                               --Number of messages processed
        BYTES,                                                                  --Total number of bytes in all messages
        BREAKS,                                                                 --Number of breaks
        CIRCUIT,                                                                --Address of the circuit currently being serviced
        IDLE/100 IDLE_SECS,                                                     --Total idle time (in hundredths of a second), so we divide by 100
        BUSY/100 BUSY_SECS,                                                     --Total busy time (in hundredths of a second)
        TO_CHAR( ROUND((BUSY/(BUSY+IDLE))*100,2), '999.00')||'%' "% BUSY",      --Percent of time busy
        IN_NET/100 INCOMING_NTWK_WAIT_SECS,                                     --Total incoming network wait time (in hundredths of a second)
        OUT_NET/100 OUTGOING_NTWK_WAIT_SECS,                                    --Total outgoing network wait time (in hundredths of a second)
        REQUESTS                                                                --Total number of requests taken from the common queue in this server's lifetime        
FROM V$SHARED_SERVER;

SELECT NAME "NAME", SUBSTR(NETWORK,1,23) "PROTOCOL", OWNED,STATUS "STATUS", (BUSY/(BUSY + IDLE)) * 100 "%TIME BUSY" FROM V$DISPATCHER;

SELECT D.NAME, Q.QUEUED, Q.WAIT, Q.TOTALQ,DECODE(Q.TOTALQ,0,0,(Q.WAIT/Q.TOTALQ)/100) "AVG WAIT" FROM V$QUEUE Q, V$DISPATCHER D WHERE D.PADDR = Q.PADDR;

SELECT Q.TYPE, Q.QUEUED, Q.WAIT, Q.TOTALQ,DECODE(Q.TOTALQ,0,0,(Q.WAIT/Q.TOTALQ)/100) "AVG WAIT" FROM V$QUEUE Q WHERE TYPE = 'COMMON';

SELECT V.INST_ID, V.SID,V.USERNAME,V.PROGRAM, V.STATUS, V.SERVER,V.MACHINE, V.LOGON_TIME, W.EVENT,W.P1,W.P1TEXT,W.P2,W.P2TEXT FROM GV$SESSION V, GV$SESSION_WAIT W WHERE W.EVENT='virtual circuit wait' AND V.SID= W.SID AND V.INST_ID = W.INST_ID;

SELECT TYPE, DECODE(TOTALQ, 0, 'no requests', WAIT/TOTALQ || ' hundredths of seconds') "average wait time per requests" FROM V$QUEUE;


SELECT USERNAME, MACHINE, TYPE, SERVER FROM GV$SESSION;

SELECT SERVER, INST_ID, COUNT(*) FROM GV$SESSION WHERE SERVER IN ('SHARED','NONE') GROUP BY SERVER, INST_ID  ORDER BY INST_ID, SERVER;

SELECT INST_ID, USERNAME, STATUS, SERVER, OSUSER, MACHINE, PROGRAM FROM GV$SESSION WHERE SERVER IN ('SHARED','NONE') AND USERNAME NOT IN ('DBSNMP','CRON_USER') ORDER BY INST_ID, SERVER;


SELECT SERVER, MACHINE, COUNT(*)
FROM GV$SESSION
WHERE /*server in ('SHARED','NONE') and */ LOGON_TIME > SYSDATE - INTERVAL '10' MINUTE
GROUP BY SERVER, MACHINE
ORDER BY MACHINE;


--==============================================================================
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_NAME = 'AUD$' AND OWNER = 'SYS';

SELECT * FROM DBA_OBJECTS WHERE OWNER = 'SHOCKEY';

SELECT * FROM DBA_AUDIT_SESSION WHERE USERNAME = 'SHOCKEY';

SELECT * FROM DBA_AUDIT_SESSION WHERE USERNAME = 'MPONNACH';

SELECT LENGTH(USER_ID), PUD.* 
FROM BRAVURA.PC_USER_DEF pud WHERE LOWER(USER_ID) = 'shockey' OR LOWER(USER_ID) = 'mponnach' OR LOWER(USER_ID) = 'erowland' OR LOWER(USER_ID) = 'sbottos';

SELECT * FROM BRAVURA.PC_USER_DEF WHERE LOWER(USER_ID) like 'stil%';

SELECT * FROM BRAVURA.PC_USER_DEF WHERE USER_SKEY = 40279;

SELECT * FROM BRAVURA.APP_USER_DEF WHERE USER_SKEY IN (SELECT USER_SKEY FROM BRAVURA.PC_USER_DEF WHERE LOWER(USER_ID) = 'shockey' OR LOWER(USER_ID) = 'mponnach' OR LOWER(USER_ID) = 'erowland');

SELECT * FROM DBA_OBJECTS WHERE OBJECT_NAME LIKE '%USER%' AND OWNER = 'BRAVURA' AND OBJECT_TYPE NOT IN ('INDEX') ORDER BY timestamp DESC;

SELECT * FROM DBA_OBJECTS WHERE                               OWNER = 'BRAVURA' AND OBJECT_TYPE NOT IN ('INDEX') ORDER BY timestamp DESC;

SELECT * FROM DBA_TAB_COLUMNS WHERE                           OWNER = 'BRAVURA' AND COLUMN_NAME = 'USER_SKEY';

--0 rows
SELECT * FROM BRAVURA.USER_MAINT WHERE USER_SKEY IN (SELECT USER_SKEY FROM BRAVURA.PC_USER_DEF WHERE LOWER(USER_ID) = 'shockey' OR LOWER(USER_ID) = 'mponnach');



SELECT * FROM DBA_TABLES WHERE TABLE_NAME = 'AUD_MTG_MP_FEE_MISC';

--696 SHOCKEY
--40279 MPONNACH
SELECT * FROM BRAVURA.USER_PREFERENCES WHERE USER_SKEY IN (SELECT USER_SKEY FROM BRAVURA.PC_USER_DEF WHERE LOWER(USER_ID) = 'shockey' OR LOWER(USER_ID) = 'mponnach');

SELECT COUNT(*) FROM BRAVURA.USER_PREFERENCES WHERE USER_SKEY = 40279;
SELECT COUNT(*) FROM BRAVURA.USER_PREFERENCES WHERE USER_SKEY = 696;

INSERT INTO BRAVURA.USER_PREFERENCES
SELECT 40279, PREFERENCE_TYPE, PREFERENCE, USER_VALUE, SYSDATE, USER, NULL, NULL
FROM BRAVURA.USER_PREFERENCES
WHERE USER_SKEY = 696;

DELETE FROM BRAVURA.USER_PREFERENCES WHERE USER_SKEY = 40279;

--==============================================================================


SELECT * FROM GV$SESSION WHERE SERVER IN ('SHARED','NONE') AND MACHINE LIKE 'mtrdb%';

--CORP\FSTROYBOXI01
--CORP\FSTROYBOXI02
SELECT * FROM GV$SESSION WHERE SERVER IN ('SHARED','NONE') AND MACHINE LIKE '%BOXI%';

SELECT SERVER, COUNT(*) FROM GV$SESSION 
WHERE MACHINE LIKE '%BOXI%'
GROUP BY SERVER;


SELECT MACHINE, COUNT(*) FROM GV$SESSION WHERE SERVER IN ('SHARED','NONE') and uPPER(MACHINE) LIKE '%CX%'  GROUP BY MACHINE;

SELECT INST_ID, SERVER, COUNT(*) FROM GV$SESSION WHERE UPPER(MACHINE) LIKE '%CX%' GROUP BY INST_ID, SERVER ORDER BY INST_ID, SERVER;

COLUMN KILL FORMAT A64
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';

SELECT logon_time, 
INST_ID, SID, SERIAL#, USERNAME, SERVER, STATUS, EVENT,
'alter system kill session '''||SID||','||SERIAL#||''' immediate;' KILL
FROM GV$SESSION S WHERE UPPER(MACHINE) LIKE '%CX%' AND SERVER <> 'DEDICATED' AND INST_ID = 6;

SELECT 'alter system kill session '''||SID||','||SERIAL#||''' immediate;' KILL
FROM GV$SESSION WHERE UPPER(MACHINE) LIKE '%CX%' AND SERVER <> 'DEDICATED' AND INST_ID = 6;


SELECT * FROM SYS.AUD$ WHERE (USERID = 'MPONNACH' OR USERID = 'MPONNAC') ORDER BY NTIMESTAMP# DESC;

SELECT ROWID, MODIFY_USER, DUMP(MODIFY_USER) FROM MTG_MP_FEE_MISC WHERE MTG_SK_SEQ = 5863056;

SELECT ROWID, MODIFY_USER, DUMP(MODIFY_USER) FROM MTG_MP_FEE_MISC WHERE modify_user like '%¿¿' and modify_date > sysdate - 1;

SELECT ROWID, MODIFY_USER, DUMP(MODIFY_USER) FROM MTG_MP_FEE_MISC WHERE trunc(modify_date) = trunc(sysdate);



--==============================================================================
--==============================================================================
SELECT MODIFY_DATE, LENGTH(MODIFY_USER)
FROM BRAVURA.AUD_MTG_MP_FEE_MISC
WHERE MODIFY_USER = 'MPONNACH'
AND MODIFY_DATE > SYSDATE -1;

SELECT MODIFY_DATE, LENGTH(MODIFY_USER)
FROM BRAVURA.MTG_MP_FEE_MISC
WHERE MODIFY_USER = 'MPONNACH'
AND MODIFY_DATE > SYSDATE -1;

alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';


SELECT * FROM V$SQL_BIND_CAPTURE WHERE LENGTH(VALUE_STRING) > MAX_LENGTH;


BRAVURA.SF_EDI_CALC_SUMM_FEES

select trunc(sysdate) from dual;
select * from sys.aud$  order by timestamp#;

SELECT ROWID, MODIFY_USER, DUMP(MODIFY_USER) FROM MTG_MP_FEE_MISC WHERE MTG_SK_SEQ = 5863056;

SELECT ROWID, MODIFY_USER, DUMP(MODIFY_USER) FROM MTG_MP_FEE_MISC WHERE MTG_SK_SEQ = 5863056 and modify_user = 'MPONNA¿¿';

SELECT ROWID, MODIFY_USER, DUMP(MODIFY_USER) FROM MTG_MP_FEE_MISC WHERE trunc(modify_date) = trunc(sysdate);



--==============================================================================
--==============================================================================
select * from bravura.pc_user_def where user_id = 'mponnach';

SELECT USER_ID, DUMP(USER_ID) FROM BRAVURA.PC_USER_DEF WHERE USER_ID = 'cvarney1'
UNION
SELECT 'cvarney1', DUMP('cvarney1') FROM DUAL;

SELECT OBJECT_ID FROM DBA_OBJECTS WHERE OBJECT_NAME = 'PC_USER_DEF' AND OWNER = 'BRAVURA';

select * from gv$locked_object where object_id = (select object_id from dba_objects where object_name = 'PC_USER_DEF' and owner = 'BRAVURA');

select * from gv$locked_object where object_id = (select object_id from dba_objects where object_name = 'MTG_HVCC_COMMENTS' and owner = 'BRAVURA');

select * from gv$locked_object where object_id = (select object_id from dba_objects where object_name = 'MTG_MP' and owner = 'BRAVURA');

select * from v$lock;