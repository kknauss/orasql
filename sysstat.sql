set pagesize 100;

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept sname  prompt 'Statistic Name... '
SET TERMOUT off;
	COLUMN sname NEW_VALUE _sname ;
	select case when '&&sname' IS NULL then 'ALL' else     lower('&&sname') end as sname from dual;
SET TERMOUT on;


select n.name, s.value
from v$sysstat s, v$statname n
where s.statistic# = n.statistic#
and ( lower(n.name) like '%&&_sname%'        OR  'all' = '&&_sname' )
order by s.value;


SET VERIFY off;

UNDEF sname
