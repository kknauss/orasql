--TTITLE "OBJECT INFORMATION FOR OBJECT_NAME LIKE &&objnm"

COL OBJECT_TYPE FORMAT A20
COL OWNER       FORMAT A18
COL OBJECT_NAME FORMAT A40
COL OBJECT      FORMAT A58
COL DATE_CREATED HEADING "CREATED ON"

--BREAK ON DATE_CREATED NODUP

SELECT to_char(created,'mm/dd/yyyy hh24:mi') as date_created, owner||'.'||object_name OBJECT, object_type, status
FROM dba_objects
WHERE object_name like upper('%&&objnm%')
ORDER BY created desc;



UNDEF objnm
--TTITLE OFF
--CLEAR COLUMNS
--SET FEEDBACK ON
