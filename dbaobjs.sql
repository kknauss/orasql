col owner format a18;
col object_name format a32;

select owner, object_name, object_type, to_char(created,'YYYY-mm-dd hh24:mi:ss') created from dba_objects where owner like '%\_DBA' escape '\' order by owner, created desc;
