SELECT ASH.USER_ID, USERNAME, COUNT(*)
FROM GV$ACTIVE_SESSION_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-22 09:25:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:30:00','YYYY-MM-DD HH24:MI:SS')
GROUP BY ASH.USER_ID, USERNAME
ORDER BY COUNT(*) DESC;


SELECT ASH.USER_ID, USERNAME, COUNT(*)
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 09:25:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:30:00','YYYY-MM-DD HH24:MI:SS')
GROUP BY ASH.USER_ID, USERNAME
ORDER BY COUNT(*) DESC;

SELECT ASH.*
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 09:25:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:50:00','YYYY-MM-DD HH24:MI:SS')
AND USERNAME = 'DW_BRAVURA_APPID'
ORDER BY SAMPLE_TIME DESC;

--445, 3115
--459,20973
SELECT ASH.*
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 08:15:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:45:00','YYYY-MM-DD HH24:MI:SS')
AND USERNAME = 'DW_BRAVURA_APPID'
and sql_id is not null
ORDER BY SAMPLE_TIME DESC;


SELECT session_id, session_serial#, count(*)
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 09:30:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:40:00','YYYY-MM-DD HH24:MI:SS')
AND USERNAME = 'DW_BRAVURA_APPID'
group by session_id, session_serial#;



SELECT distinct session_id sid, session_serial# serial
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 09:30:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:40:00','YYYY-MM-DD HH24:MI:SS')
AND USERNAME = 'DW_BRAVURA_APPID'
order by session_id;


SELECT ASH.*
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 09:30:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:40:00','YYYY-MM-DD HH24:MI:SS')
AND USERNAME = 'DW_BRAVURA_APPID'
order by session_id;

SELECT * FROM GV$INSTANCE;

SELECT USERNAME, ASH.*
FROM DBA_HIST_ACTIVE_SESS_HISTORY ASH, DBA_USERS U
WHERE ASH.USER_ID = U.USER_ID
AND SAMPLE_TIME BETWEEN TO_DATE('2011-09-20 09:25:00','YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2011-09-20 09:30:00','YYYY-MM-DD HH24:MI:SS')
and ASH.SESSION_ID = 546 and ASH.SESSION_SERIAL# =1
order by session_id;