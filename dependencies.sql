set linesize 132;
set pagesize 124;

column owner format a12;
column name  format a24;
column referenced_owner format a12;
column referenced_name format a32;

select owner, name, type, referenced_owner, referenced_name, referenced_type
from dba_dependencies
where owner = upper('&own')
and name = upper('&name')
and referenced_owner <> 'SYS'
order by owner, name, type;
