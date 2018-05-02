column owner format a18;
column name format a28;
column object_name format a32;
column status format a7;
column text format a72; 
column message_number format 999 heading 'Msg|Nbr';


select e.owner, e.name, e.type, e.line, e.position, e.text
from dba_errors e, dba_objects o
where e.owner = o.owner
and e.type = o.object_type
and e.name = o.object_name
and o.status <> 'VALID'
and o.owner = upper('&schema')
order by e.owner, e.name, e.type, e.sequence;
