break on group# on thread# on sequence# on bytes on members on archived on status on first_change# on first_time

column GROUP#         heading 'Group|#'        format      9999;
column DBID           heading 'DBID'           format       a12;
column THREAD#        heading 'Thread|#'       format        99;
column SEQUENCE#      heading 'Sequence|#'     format  99999999;
column BYTES          heading 'Total|Bytes'    format  9999999999;
column MEMBERS        heading 'Number|Members' format         9;
column USED           heading 'Used|Bytes'     format  99999999;
column ARCHIVED       heading 'Archvd|?'       format        a6;
column STATUS         heading 'Status'         format       a18;
column FIRST_CHANGE#  heading 'First|SCN'      format  999999999999;
column FIRST_TIME     heading 'First Time';
column MEMBER         heading 'Member Name'    format       a42;

SELECT L.*, LF.MEMBER FROM V$LOG L, V$LOGFILE LF WHERE L.GROUP# = LF.GROUP# ORDER BY L.GROUP#;
