column PROCESS        heading 'Process'        format       a12;
column PID            heading 'Process|ID'     format  99999999;
column STATUS         heading 'Status'         format       a12;
column CLIENT_PROCESS heading 'Client|Process' format        a8;
column CLIENT_PID     heading 'Client|PID'     format        a9;
column CLIENT_DBID    heading 'Client|DBID'    format       a12;
column GROUP#         heading 'Group#'         format        a6;
column RESETLOG_ID    heading 'Resetlogs|ID'   format 999999999;
column THREAD#        heading 'Thread|#'       format        99;
column SEQUENCE#      heading 'Sequence #'     format  99999999;
column BLOCK#         heading 'Block #'        format  99999999;
column BLOCKS         heading 'Blocks'         format  99999999;
column DELAY_MINS     heading 'Delay|Mins'     format  99999999;
column KNOWN_AGENTS   heading 'Known|Agents'   format  99999999;
column ACTIVE_AGENTS  heading 'Active|Agents'  format  99999999;

SELECT * FROM V$MANAGED_STANDBY ORDER BY PROCESS;

--ear columns
