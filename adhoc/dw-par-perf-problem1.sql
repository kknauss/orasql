ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';

SELECT * FROM V$RSRC_PLAN_HISTORY;
SELECT * FROM V$RSRC_CONS_GROUP_HISTORY WHERE SEQUENCE# = (SELECT SEQUENCE# FROM V$RSRC_PLAN_HISTORY WHERE END_TIME IS NULL) ORDER BY ID;
SELECT * FROM V$RSRC_CONSUMER_GROUP;

SELECT * FROM V$RSRC_SESSION_INFO WHERE MAPPED_CONSUMER_GROUP = 'FS_BATCH_GROUP';
SELECT * FROM V$RSRC_SESSION_INFO WHERE SID = 528;

SELECT * FROM V$RSRC_CONSUMER_GROUP_CPU_MTH;
SELECT * FROM V$RSRC_PLAN;
SELECT * FROM V$RSRC_PLAN_CPU_MTH;

SELECT SE.SID SESS_ID, CO.NAME CONSUMER_GROUP, SE.STATE, SE.CONSUMED_CPU_TIME CPU_TIME, SE.CPU_WAIT_TIME, SE.QUEUED_TIME
FROM V$RSRC_SESSION_INFO SE, V$RSRC_CONSUMER_GROUP CO
WHERE SE.CURRENT_CONSUMER_GROUP_ID = CO.ID
AND CO.NAME = 'FS_BATCH_GROUP';