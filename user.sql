SET VERIFY off;
REM SET VERIFY on;

column username     format  a20    heading 'Username';
column program      format  a42    heading 'Program';
column machine      format  a32    heading 'Machine';
column osuser       format  a12    heading 'OS User';
column inst_id      format    9    heading 'In|st';
column logontime    format  a17    heading 'Logon Time';
column status       format   a2    heading 'St|at|us';
column sid          format  999999; 
column spid         format      a8 heading 'Server|PID' JUSTIFY RIGHT;
column serial#      format  999999 heading 'Serial#';
column last_call_et format 99999999 heading 'Last|Call|Elap(s)';
column event        format  a48    heading 'Wait Event';
column server       format  a10;

UNDEF instid
UNDEF sspid
UNDEF orasid
UNDEF usernm
UNDEF progrm
UNDEF machn
UNDEF sstatu


SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept instid prompt 'Instance ID...... '
	accept orasid prompt 'Session ID....... '
	accept sspid  prompt 'Session OS PID... '
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
	COLUMN orasid NEW_VALUE _orasid ;

	select case when '&&instid' IS NULL then 0     else to_number('&&instid') end as instid from dual;
	select case when '&&sspid'  IS NULL then 0     else to_number('&&sspid')  end as sspid  from dual;
	select case when '&&orasid' IS NULL then 0     else to_number('&&orasid') end as orasid from dual;
	select case when '&&usernm' IS NULL then 'ALL' else     upper('&&usernm') end as usernm from dual;
	select case when '&&progrm' IS NULL then 'ALL' else     upper('&&progrm') end as progrm from dual;
	select case when '&&machn'  IS NULL then 'ALL' else     upper('&&machn')  end as machn  from dual;
	select case when '&&sstatu' IS NULL then 'ALL' else     upper('&&sstatu') end as sstatu from dual;
SET TERMOUT on;



select	a.inst_id, a.username, a.sid, a.serial#, lpad(c.spid,8) spid, server,
case a.status when 'ACTIVE' then 'A' when 'INACTIVE' then 'I' when 'KILLED' then 'K' else '?' end status, a.last_call_et, a.machine, a.osuser, a.program, a.sql_id, to_char(logon_time,'mm/dd/yy hh24:mi:ss') as logontime, a.event
from	gv$session a, gv$process c
where	a.inst_id = c.inst_id(+)
--and	type <> 'BACKGROUND'
and	a.paddr   = c.addr(+)
and	( a.inst_id = &&_instid                OR     0  =  &&_instid )
and	( a.sid = &&_orasid                    OR     0  =  &&_orasid )
and	( c.spid = &&_sspid                    OR     0  =  &&_sspid )
and	( a.username like '%&&_usernm%'        OR  'ALL' = '&&_usernm' )
and	( upper(a.program) like '%&&_progrm%'  OR  'ALL' = '&&_progrm' )
and	( upper(a.machine) like '%&&_machn%'   OR  'ALL' = '&&_machn' )
and	( a.status like '&&_sstatu%'           OR  'ALL' = '&&_sstatu' )
order by last_call_et ;
--order by logontime desc;

REM DEFINE 

UNDEF instid
UNDEF sspid
UNDEF orasid
UNDEF usernm
UNDEF progrm
UNDEF machn
UNDEF sstatu
