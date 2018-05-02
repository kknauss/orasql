Rem
Rem $Header: mts.sql 23-Mar-98.13:50:59 kareardo
Rem
Rem Copyright (c) 1999 by Oracle Corporation
Rem NAME
Rem MTS.SQL
Rem FUNCTION
Rem This script will generate a report (in "report.txt") which will
Rem contain usefull information for performance monitoring for Oracle 
Rem Multi-Threaded Server.
Rem It spools information from v$dispatchers, v$shared_servers,
Rem v$queue, v$mts, v$dispatcher_rate.
Rem NOTES
Rem None
Rem MODIFIED 
Rem kareardo 12/12/2000 - Added query on v$mts and fixed queries
Rem kareardo 11/6/2000 - Added more state querying for dispatchers,
Rem shared servers, their queues, 
Rem rates and some on the large pool
Rem kareardo 3/23/1999 - Creation
Rem *******************************************************************
Rem Begin script to spool to report.txt
Rem *******************************************************************
set echo on;
spool mts_report.txt;

set numwidth 10
set linesize 132
set pagesize 100

column status format A15
column network format A20

Rem Validate that this size is OK for the system you are running on.
alter session set sort_area_size = 10000000; 

Rem *******************************************************************
Rem Output SGA and UGA Statistics
Rem *******************************************************************
Rem Oracle allocates some fixed amount of memory (about 10K) per configured 
Rem session from the shared pool, even if you have configured the large pool. 
Rem The MTS_CIRCUITS initialization parameter specifies the maximum number 
Rem of concurrent MTS connections that the database allows. For information 
Rem on the MTS_CIRCUITS parameter, see Oracle8i Reference. 
Rem 
Rem The amount of free memory in the shared pool is reported in V$SGASTAT. 
Rem Report the current value from this view using the following query: 
Rem 
Rem These two selects are to monitor the UGA space for MTS connections. 
Rem Check to see if the large pool free memory is not too small which
Rem could prevent session growth and possible UGA growth.
Rem View:X$KSMLS gives an indication of space usage within the 
Rem large pool.

SELECT * FROM v$sysstat WHERE name like '%uga%';

select POOL, name, BYTES
from V$SGASTAT
where name = 'VIRTUAL CIRCUITS'
or name = 'processes'
or name = 'sessions'
or name = 'free memory' 
and (POOL like '%large%' or POOL like '%shared%')
order by POOL;

Rem Because it is better to measure statistics during a confined period than 
Rem from startup, you can determine the library cache and row cache (data 
Rem dictionary cache) hit ratios from the following queries. The results show 
Rem the miss rates for the library cache and row cache. In general, the number 
Rem of reparses reflects the library cache. If the ratios are close to 1, then 
Rem you do not need to increase the pool size. 

SELECT (SUM(PINS - RELOADS)) / SUM(PINS) "LIB CACHE"
FROM V$LIBRARYCACHE;

SELECT (SUM(GETS - GETMISSES - USAGE - FIXED)) / SUM(GETS) "ROW CACHE"
FROM V$ROWCACHE;

Rem You can use the following queries to decide how much larger to make the shared 
Rem pool if you are using a Multi-threaded Server. These queries also select from 
Rem the dynamic performance table V$STATNAME to obtain internal identifiers for 
Rem session memory and max session memory. Issue these queries while your 
Rem application is running: 

SELECT SUM(VALUE)/(1024*1024) || ' MB' "TOTAL MEMORY FOR ALL SESSIONS"
FROM V$SESSTAT, V$STATNAME
WHERE NAME = 'session uga memory'
AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#;

SELECT SUM(VALUE)/(1024*1024) || ' MB' "TOTAL MAX MEM FOR ALL SESSIONS" 
FROM V$SESSTAT, V$STATNAME
WHERE NAME = 'session uga memory max'
AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#;

Rem *******************************************************************
Rem Queries on Dispatcher Statistics
Rem *******************************************************************
select * from v$mts;
select * from v$license;

Rem This query returns the average time, in hundredths of a second, that a response 
Rem waits in each response queue for a dispatcher process to route it to a user 
Rem process. This query uses the V$DISPATCHER table to group the rows of the V$QUEUE 
Rem table by MTS_DISPATCHERS parameter value index. The query also uses the DECODE 
Rem syntax to recognize those protocols for which there have been no responses in the 
Rem queue.

SELECT d.name, network,
DECODE( SUM(totalq), 0, 'No Responses', 
SUM(wait)/SUM(totalq) || ' Hundredths of Seconds') 
"Average Wait Time per Response"
FROM v$queue q, v$dispatcher d 
WHERE q.type = 'DISPATCHER' AND q.paddr = d.paddr 
GROUP BY d.name, network;

Rem If dispatchers start starving, then more need to be added. To find out how
Rem busy the dispatchers are, this query is run.

select network, name, STATUS,((BUSY/(BUSY+IDLE))*100) "Busy Rate",BREAKS, MESSAGES, CREATED, OWNED, ACCEPT, LISTENER "Last Listener Error"
from V$DISPATCHER;

Rem *******************************************************************
Rem Queries on Shared Server Statistics
Rem *******************************************************************
Rem To list the state and number of Shared Servers there are. To also
Rem show the relitive time busy the Shared Servers are. This latter
Rem number is a little tricky to understand as there are times where
Rem the idle time will far exceed busy, and the Shared Surver will
Rem appear that it is not doing anything.

SELECT NAME, STATUS, ((BUSY/(BUSY + IDLE))*100) "%Time Busy", BREAKS, MESSAGES, CIRCUIT, REQUESTS
FROM GV$SHARED_SERVER;


SELECT * FROM V$CIRCUIT WHERE STATUS = 'NORMAL';

SELECT SUM(MESSAGES), SUM(BYTES), SUM(BREAKS) FROM V$CIRCUIT WHERE DISPATCHER = (SELECT PADDR FROM V$DISPATCHER WHERE NAME = 'D000');
SELECT SUM(MESSAGES), SUM(BYTES), SUM(BREAKS) FROM V$CIRCUIT WHERE DISPATCHER = (SELECT PADDR FROM V$DISPATCHER WHERE NAME = 'D003');
SELECT * FROM V$DISPATCHER;
SELECT * FROM V$SESSION WHERE PADDR = '07000003CAC82568';
SELECT * FROM V$PROCESS WHERE  ADDR IN (SELECT PADDR FROM V$DISPATCHER);
SELECT D.NAME, Q.* FROM V$QUEUE Q, V$DISPATCHER D WHERE D.PADDR = Q.PADDR;

Rem *******************************************************************
Rem Output on MTS Queue Statistics
Rem *******************************************************************
Rem These querys conveys information on the multi-thread message queues. 

select 
  type "Queue Type", QUEUED "Requests Queued",
  (case when TOTALQ = 0 then 0 else (wait/TOTALQ) end) "Average wait per item",
  TOTALQ "Total"
from V$QUEUE 
where type = 'COMMON';

SELECT type "Queue Type", queued "Requests Queued",
(case when totalq = 0 
then 0 
else (wait/totalq) 
end) "Average wait per item",
totalq "Total", name
FROM v$queue q, v$dispatcher d
where q.paddr = d.paddr;

Rem This query may not work. Shared Servers may never own a queue long
Rem enough to show up. Will experiment.
SELECT type "Queue Type", queued "Requests Queued",
(case when totalq = 0 
then 0 
else (wait/totalq) 
end) "Average wait per item",
totalq "Total", name
FROM v$queue q, v$shared_server s
where q.paddr = s.paddr;

select name, TTL_LOOPS,TTL_MSG,TTL_SVR_BUF,TTL_CLT_BUF,TTL_BUF,
TTL_IN_CONNECT,TTL_OUT_CONNECT,TTL_RECONNECT,
SCALE_LOOPS,SCALE_MSG,SCALE_SVR_BUF,SCALE_CLT_BUF,
SCALE_BUF,SCALE_IN_CONNECT,SCALE_OUT_CONNECT,SCALE_RECONNECT
from v$dispatcher_rate; 

Rem To show the current/average/max events the dispatcher has been processing in each 
Rem iteration through its dispatching loop

SELECT NAME "Current Events", CUR_EVENTS_PER_LOOP, AVG_EVENTS_PER_LOOP, MAX_EVENTS_PER_LOOP 
FROM V$DISPATCHER_RATE;

Rem *******************************************************************
Rem Connection Statistics for Dispatchers
Rem *******************************************************************
Rem To show the current/average/max inbound connection rate to the dispatchers
Rem To determine the number of outbound connections FROM the dispatchers
Rem Outbound connections would be dblinks, etc. To determine the number of 
Rem reconnects when configured for Connection Pooling:

SELECT NAME,
CUR_IN_CONNECT_RATE "CurrInbound", 
CUR_RECONNECT_RATE "CurrReconnect", 
CUR_OUT_CONNECT_RATE "CurrOutbound",
AVG_IN_CONNECT_RATE "AvgInbound", 
AVG_RECONNECT_RATE "AvgReconnect", 
AVG_OUT_CONNECT_RATE "AvgOutbound",
MAX_IN_CONNECT_RATE "MaxInbound", 
MAX_RECONNECT_RATE "MaxReconnect", 
MAX_OUT_CONNECT_RATE "MaxOutbound"
FROM V$DISPATCHER_RATE;

Rem *******************************************************************
Rem Dispatcher Buffer/Byte Rates
Rem *******************************************************************

select NAME, CUR_BUF_RATE "CurrBuffRate",
(case when CUR_BUF_RATE = 0 then 0
else ((CUR_SVR_BUF_RATE/CUR_BUF_RATE)*100) end) "%BuffServer",
(case when CUR_BUF_RATE = 0 then 0
else ((CUR_CLT_BUF_RATE/CUR_BUF_RATE)*100) end) "%BuffClient",
CUR_BYTE_RATE "CurrByteRate",
(case when CUR_BYTE_RATE = 0 then 0
else ((CUR_SVR_BYTE_RATE/CUR_BYTE_RATE)*100) end) "%ByteServer",
(case when CUR_BYTE_RATE = 0 then 0
else ((CUR_CLT_BYTE_RATE/CUR_BYTE_RATE)*100) end) "%ByteClient"
from v$dispatcher_rate;

select NAME, AVG_BUF_RATE "AvgBuffRate",
(case when AVG_BUF_RATE = 0 then 0
else ((AVG_SVR_BUF_RATE/AVG_BUF_RATE)*100) end) "%BuffServer",
(case when AVG_BUF_RATE = 0 then 0
else ((AVG_CLT_BUF_RATE/AVG_BUF_RATE)*100) end) "%BuffClient",
AVG_BYTE_RATE "AvgByteRate",
(case when AVG_BYTE_RATE = 0 then 0
else ((AVG_SVR_BYTE_RATE/AVG_BYTE_RATE)*100) end) "%ByteServer",
(case when AVG_BYTE_RATE = 0 then 0
else ((AVG_CLT_BYTE_RATE/AVG_BYTE_RATE)*100) end) "%ByteClient"
From v$dispatcher_rate;

select NAME, MAX_BUF_RATE "MaxBuffRate",
(case when MAX_BUF_RATE = 0 then 0
else ((MAX_SVR_BUF_RATE/MAX_BUF_RATE)*100) end) "%BuffServer",
(case when MAX_BUF_RATE = 0 then 0
else ((MAX_CLT_BUF_RATE/MAX_BUF_RATE)*100) end) "%BuffClient",
MAX_BYTE_RATE "MaxByteRate",
(case when MAX_BYTE_RATE = 0 then 0
else ((MAX_SVR_BYTE_RATE/MAX_BYTE_RATE)*100) end) "%ByteServer",
(case when MAX_BYTE_RATE = 0 then 0
else ((MAX_CLT_BYTE_RATE/MAX_BYTE_RATE)*100) end) "%ByteClient"
from v$dispatcher_rate;

Rem *******************************************************************
Rem Clearing up previous settings
Rem *******************************************************************
column status clear
column network clear

SPOOL off;
