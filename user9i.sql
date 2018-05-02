SET VERIFY off;

column username format a20    heading 'Username';
column program  format a48    heading 'Program';
column machine  format a28    heading 'Machine';
column inst_id  format  09    heading 'Inst|ID';
column logontime              heading 'Logon Time';
column status                 heading 'Status';
column sid      format 999999; 
column serial#  format 999999 heading 'Serial#';
column last_call_et format 999999 heading 'Last Call|Elapsed(s)';
column event    format a50   heading 'Wait Event';

UNDEF instid
UNDEF usernm
UNDEF machn
UNDEF progrm

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept instid prompt 'Instance ID...... '
	accept sid    prompt 'Session ID....... '
	accept sspid  prompt 'Session PID...... '
	accept usernm prompt 'User Name........ '
	accept sstatu prompt 'Session Status... '
	accept progrm prompt 'Program Name..... '
	accept machn  prompt 'Machine Name..... '
SET TERMOUT off;
	COLUMN instid NEW_VALUE _instid ;
	COLUMN usernm NEW_VALUE _usernm ;
	COLUMN progrm NEW_VALUE _progrm ;
	COLUMN machn  NEW_VALUE _machn  ;
	COLUMN sstatu NEW_VALUE _sstatu ;
	COLUMN sspid  NEW_VALUE _sspid ;
	COLUMN sid    NEW_VALUE _sid ;

	select case when '&&instid' IS NULL then 0     else to_number('&&instid') end as instid from dual;
	select case when '&&sspid'  IS NULL then 0     else to_number('&&sspid')  end as sspid  from dual;
	select case when '&&sid'    IS NULL then 0     else to_number('&&sid')    end as sid    from dual;
	select case when '&&usernm' IS NULL then 'ALL' else     upper('&&usernm') end as usernm from dual;
	select case when '&&progrm' IS NULL then 'ALL' else     upper('&&progrm') end as progrm from dual;
	select case when '&&machn'  IS NULL then 'ALL' else     upper('&&machn')  end as machn  from dual;
	select case when '&&sstatu' IS NULL then 'ALL' else     upper('&&sstatu') end as sstatu from dual;
SET TERMOUT on;



--select	a.inst_id, a.username, a.sid, a.serial#, c.spid, a.status, a.last_call_et, machine, a.program, to_char(logon_time,'mm/dd/yyyy hh24:mi:ss') as logontime, a.event
select	a.inst_id, a.username, a.sid, a.serial#, c.spid, a.status, a.last_call_et, machine, a.program, to_char(logon_time,'mm/dd/yyyy hh24:mi:ss') as logontime
from	gv$session a, gv$process c
where	type <> 'BACKGROUND'
and	a.inst_id = c.inst_id
and	a.paddr   = c.addr
and	( a.inst_id = &&_instid                OR     0  =  &&_instid )
and	( a.sid = &&_sid                       OR     0  =  &&_sid )
and	( c.spid = &&_sspid                    OR     0  =  &&_sspid )
and	( a.username like '&&_usernm%'         OR  'ALL' = '&&_usernm' )
and	( upper(a.program) like '%&&_progrm%'  OR  'ALL' = '&&_progrm' )
and	( upper(a.machine) like '%&&_machn%'   OR  'ALL' = '&&_machn' )
and	( a.status like '&&_sstatu%'           OR  'ALL' = '&&_sstatu' )
order by logontime desc;
