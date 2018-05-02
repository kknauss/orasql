column owner format a16;
column object_name format a24;

select oracle_username, os_user_name, session_id, process,
       locked_mode, o.owner, o.object_type, o.object_name
  from sys.dba_objects o,
       v$locked_object l
 where l.object_id = o.object_id
 order by o.owner, o.object_name, session_id;
