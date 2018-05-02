COL OBJECT_TYPE FORMAT A20
COL OWNER       FORMAT A18
COL OBJECT_NAME FORMAT A40
COL OBJECT      FORMAT A58
COL DATE_CREATED HEADING "CREATED ON"


SELECT * --to_char(created,'mm/dd/yyyy hh24:mi') as date_created, owner||'.'||object_name OBJECT, object_type, status
FROM dba_objects
WHERE object_id = &objid
ORDER BY created desc;
