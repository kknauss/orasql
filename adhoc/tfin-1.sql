select * from DBA_HIST_ACTIVE_SESS_HISTORY where sql_id = '601fmbuyud48f' order by sample_time desc;

ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';

SELECT * FROM DBA_HIST_SQL_PLAN WHERE SQL_ID = '601fmbuyud48f' ORDER BY TIMESTAMP, ID;

SELECT SNAP.END_INTERVAL_TIME, SS.*
FROM DBA_HIST_SQLSTAT SS, (SELECT SNAP_ID, END_INTERVAL_TIME FROM DBA_HIST_SNAPSHOT WHERE DBID = (SELECT DBID FROM V$DATABASE)) SNAP
WHERE SQL_ID = '601fmbuyud48f'
AND SS.SNAP_ID = SNAP.SNAP_ID
ORDER BY SS.SNAP_ID DESC;


SELECT SNAP_ID, END_INTERVAL_TIME FROM DBA_HIST_SNAPSHOT WHERE DBID = (SELECT DBID FROM V$DATABASE);


SELECT * FROM V$SESSION WHERE SID = 395;

select * from V$SQL_PLAN where 