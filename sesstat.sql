set pagesize 100;

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept sname  prompt 'Statistic Name... '
SET TERMOUT off;
	COLUMN sname NEW_VALUE _sname ;
	select case when '&&sname' IS NULL then 'all' else     lower('&&sname') end as sname from dual;
SET TERMOUT on;

select
	n.name,
	decode (bitand(  1,n.class),  1,'User-',     '') ||
	decode (bitand(  2,n.class),  2,'Redo-',     '') ||
	decode (bitand(  4,n.class),  4,'Enqueue-',  '') ||
	decode (bitand(  8,n.class),  8,'Cache-',    '') ||
	decode (bitand( 16,n.class), 16,'OS-',       '') ||
	decode (bitand( 32,n.class), 32,'RAC-',      '') ||
	decode (bitand( 64,n.class), 64,'SQL-',      '') ||
	decode (bitand(128,n.class),128,'Debug',     '') class,
	s.value
from gv$sesstat s, gv$statname n
where s.inst_id = &&inst_id
and s.inst_id = n.inst_id
and s.statistic# = n.statistic#
and s.sid = &&sid
and ( lower(n.name) like '%&&_sname%'        OR  'all' = '&&_sname' )
and s.value > 0
order by lower(n.name)
;

SET VERIFY off;

UNDEF sname
