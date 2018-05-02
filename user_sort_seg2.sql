column status       format a12     heading 'Status';
column extents      format 999999  heading 'Number|Extents';
column segtype                     heading 'Segment|Type';
column MB_used                     heading 'MB|Used';
column sid          format  999999; 
column serial#      format  999999 heading 'Serial#';
column tablespace   format   a12   heading 'Tablespace';
column username     format  a20    heading 'Username';
column program      format  a42    heading 'Program';
column machine      format  a32    heading 'Machine';
column osuser       format  a12    heading 'OS User';
column inst_id      format    9    heading 'In|st';


select	
	s.inst_id, s.sid, s.serial#, s.username, s.status, s.sql_id, t.tablespace, t.segtype, t.extents, t.blocks * b.block_size / 1024 / 1024 mb_used
from
	gv$session s,
	gv$tempseg_usage t,
	dba_tablespaces b
where
	s.inst_id        = t.inst_id
and	s.saddr          = t.session_addr
and	t.tablespace     = b.tablespace_name
order by t.blocks desc;
