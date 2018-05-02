set pagesize 55;
column owner format a12;
column name  format a52;

select owner, name, sharable_mem
from v$db_object_cache
where type in ('PACKAGE','PACKAGE BODY')
order by sharable_mem desc;
