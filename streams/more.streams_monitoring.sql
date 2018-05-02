--Troubleshooting Capture Problems

  --Is the Capture Process Enabled?
    SELECT CAPTURE_NAME, STATUS,STATUS_CHANGE_TIME, ERROR_NUMBER, ERROR_MESSAGE
    FROM DBA_CAPTURE;


  --Is the Capture Process Current?
    SELECT CAPTURE_NAME, STATE FROM V$STREAMS_CAPTURE;

/*
  If the capture process state is either WAITING FOR DICTIONARY REDO or WAITING FOR REDO, 
  then verify that the redo log files have been registered with the downstream capture.
  For example, the following query lists the redo log files currently registered capture process(es).
*/
    COLUMN SOURCE_DATABASE HEADING 'Source|Database' FORMAT A15
    COLUMN SEQUENCE# HEADING 'Sequence|Number' FORMAT 9999999
    COLUMN NAME HEADING 'Archived Redo Log|File Name' FORMAT A30
    COLUMN DICTIONARY_BEGIN HEADING 'Dictionary|Build|Begin' FORMAT A10
    COLUMN DICTIONARY_END HEADING 'Dictionary|Build|End' FORMAT A10

    SELECT c.CAPTURE_NAME,
           r.SOURCE_DATABASE,
           r.SEQUENCE#, 
           r.NAME, 
           r.DICTIONARY_BEGIN, 
           r.DICTIONARY_END 
      FROM DBA_REGISTERED_ARCHIVED_LOG r, DBA_CAPTURE c
      WHERE r.CONSUMER_NAME = c.CAPTURE_NAME;
