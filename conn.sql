SET VERIFY off;

column program format a42;
column osuser format a22;
column username format a20;
column machine format a42;

break on report;
compute sum of count(*) on report;
undef instid
undef machn

select inst_id, count(*)
from gv$session
where type <> 'BACKGROUND'
group by inst_id
order by inst_id;


/*

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept instid prompt 'Instance ID...... '
	accept machn  prompt 'Machine.......... '
SET TERMOUT off;
	COLUMN instid NEW_VALUE _instid ;
	COLUMN machn  NEW_VALUE _machn  ;
	select case when '&&instid' IS NULL then 0     else to_number('&&instid') end as instid from dual;
	select case when '&&machn'  IS NULL then 'ALL' else     upper('&&machn')  end as machn  from dual;
SET TERMOUT on;



select inst_id, machine, count(*)
from gv$session
where type <> 'BACKGROUND'
and ( inst_id = &&_instid               OR     0  =  &&_instid )
and ( upper(machine) like '%&&_machn%'  OR  'ALL' = '&&_machn' )
group by inst_id, machine
order by inst_id, count(*) desc;

*/


undef instid
undef machn
