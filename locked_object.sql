column owner       format a18 heading 'Owner';
column object_name format a32 heading 'Object Name';
column object_type format a16 heading 'Object Type';
column osuser      format a12 heading 'OS User';
column status      format  a8 heading 'Status';
column lock_mode   format a17 heading 'Lock Mode';
column machine     format a20 heading 'Machine';


select
   c.owner,
   c.object_name,
   c.object_type,
	case a.locked_mode
		when 0 then '0 - none'
		when 1 then '1 - null (NULL)'
		when 2 then '2 - row-S (SS)'
		when 3 then '3 - row-X (SX)'
		when 4 then '4 - share (S)'
		when 5 then '5 - S/Row-X (SSX)'
		when 6 then '6 - exclusive (X)'
	end lock_mode,
   b.username,
   b.sid,
   b.serial#,
   b.status,
   b.osuser,
   b.machine
from
   gv$locked_object a ,
   gv$session b,
   dba_objects c
where
   b.inst_id = a.inst_id
and
   b.sid = a.session_id
--and c.object_name = upper('VW_LIST_VALUE_LKUP')
and
   a.object_id = c.object_id;
