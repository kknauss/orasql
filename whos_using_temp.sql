column ii          format    09   heading 'Inst|ID';
column sid         format 99999;
column serial#     format 99999   heading 'Serial#';
column extents     format  9999   heading 'Number|Extents';
column mb_used     format 99999   heading 'MB|Used';
column username    format   a18   heading 'User';
column tablespace  format   a12   heading 'Tablespace';
column sql_text    format  a120   heading 'SQL Text';
column status                     heading 'Status';
column segtype                    heading 'Segment|Type';

select	
	s.inst_id ii, s.sid, s.serial#, s.username, s.status, 
	t.tablespace, t.segtype, t.extents, t.blocks * b.block_size / 1024 / 1024 mb_used, a.sql_id,
	a.sql_text
from
	gv$session s,
	gv$tempseg_usage t,
	dba_tablespaces b,
	gv$sqlarea a
where
	s.inst_id        = t.inst_id
and	s.saddr          = t.session_addr
and	s.inst_id        = a.inst_id(+)
and	s.sql_hash_value = a.hash_value(+)
and	s.sql_address    = a.address(+)
and	t.tablespace     = b.tablespace_name
order by t.blocks desc;
