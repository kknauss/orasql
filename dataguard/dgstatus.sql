column message format a100;

break on facility on severity on dest_id on error_code on timestamp

SELECT FACILITY, SEVERITY, DEST_ID, ERROR_CODE, TIMESTAMP, MESSAGE
FROM V$DATAGUARD_STATUS
WHERE TIMESTAMP > SYSDATE - 2 
ORDER BY MESSAGE_NUM DESC;
