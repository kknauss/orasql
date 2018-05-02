set linesize 120
set pagesize 66;
column owner format a12;
column name  format a52;

select owner, name, type
from v$db_object_cache
where kept = 'YES';
