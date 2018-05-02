column owner format a18;
column object_name format a32;
column status format a7;
column text format a100; 
column message_number format 999 heading 'Msg|Nbr';

select owner, status, count(*)
from dba_objects
where status <> 'VALID'
group by  owner, status
order by  owner, status ;

select 
	case object_type
		when 'PACKAGE BODY' then 'alter PACKAGE ' || owner ||'.'|| object_name || ' compile BODY;'
		else 'alter '||object_type || ' ' || owner ||'.'|| object_name || ' compile;'
	end
from dba_objects
where owner = upper('&&schema')
and status <> 'VALID'
order by object_type, object_name;

select e.owner, e.name, e.type, e.sequence, e.line, e.position, e.text
from dba_errors e, dba_objects o
where e.owner = o.owner
and e.type = o.object_type
and e.name = o.object_name
and o.status <> 'VALID'
and o.owner = upper('&&schema')
order by e.owner, e.type, e.name, e.sequence;

undef schema
