col compilecmd format a112;

select 'exec DBMS_UTILITY.COMPILE_SCHEMA (schema=>'''||owner||''',compile_all=>FALSE);' compilecmd
from dba_objects
where status <> 'VALID'
group by  owner
order by  owner;
