set pagesize 50000
set markup html on
set markup html on

spool shared_servers_check.html

Show parameter shared
show parameter circuit
show parameter dispatcher

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

select NAME,STATUS,requests, idle/100, busy/100,(busy/(busy+idle))*100 busy,MESSAGES,BREAKS,CIRCUIT,REQUESTS from v$shared_server;

SELECT NAME "NAME", SUBSTR(NETWORK,1,23) "PROTOCOL", OWNED,STATUS "STATUS", (BUSY/(BUSY + IDLE)) * 100 "%TIME BUSY" FROM V$DISPATCHER;

SELECT D.NAME, Q.QUEUED, Q.WAIT, Q.TOTALQ,DECODE(Q.TOTALQ,0,0,(Q.WAIT/Q.TOTALQ)/100) "AVG WAIT" FROM V$QUEUE Q, V$DISPATCHER D WHERE D.PADDR = Q.PADDR;

SELECT Q.TYPE, Q.QUEUED, Q.WAIT, Q.TOTALQ,DECODE(Q.TOTALQ,0,0,(Q.WAIT/Q.TOTALQ)/100) "AVG WAIT" FROM V$QUEUE Q WHERE TYPE = 'COMMON';

select v.inst_id, v.sid,V.USERNAME,v.program, v.status, v.server,v.machine, V.LOGON_TIME, w.event,w.p1,w.p1text,w.p2,w.p2text from gv$session v, gv$session_wait w where w.event='virtual circuit wait' and v.sid= w.sid and v.inst_id = w.inst_id;

select type, decode(totalq, 0, 'no requests', wait/totalq || ' hundredths of seconds') "average wait time per requests" from v$queue;

set markup html off

spool off
