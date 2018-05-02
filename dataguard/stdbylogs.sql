break on group# on dbid on thread# on sequence# on bytes on used on archived on status on first_change# on first_time on last_change# on last_time

column GROUP#         heading 'Group|#'        format          9999;
column DBID           heading 'DBID'           format           a12;
column THREAD#        heading 'Thread|#'       format            99;
column SEQUENCE#      heading 'Sequence|#'     format      99999999;
column BYTES          heading 'Total|Bytes'    format      99999999;
column USED           heading 'Used|Bytes'     format      99999999;
column ARCHIVED       heading 'Archvd|?'       format            a6;
column STATUS         heading 'Status'         format           a12;
column FIRST_CHANGE#  heading 'First|SCN'      format  999999999999;
column FIRST_TIME     heading 'First Time';
column LAST_CHANGE#   heading 'Last|SCN'       format  999999999999;
column LAST_TIME      heading 'Last Time';
column MEMBER         heading 'Member Name'    format           a42;

SELECT SL.*, LF.MEMBER FROM V$STANDBY_LOG SL, V$LOGFILE LF WHERE SL.GROUP# = LF.GROUP# ORDER BY SL.GROUP#;
