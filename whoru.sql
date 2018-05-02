column inst_id    format   99     heading 'In|st';
column spid       format  a10     heading 'Server|PID';
column sess       format  a12     heading 'Session ID';
column server                     heading 'Server|Type';
column machine    format  a22     heading 'Machine';
column program    format  a22     heading 'Program';
column username   format  a15     heading 'Username';
column status     format   a8     heading 'Status';
column command    format  a100     heading 'SQL Trace Command';
column logontime  format  a17     heading 'Logon Time';
column trenabled  format   a4     heading 'Trace|Enab|led?';
column waenabled  format   a4     heading 'Wait|Enab|led?';
column bienabled  format   a4     heading 'Bind|Enab|led?';
column trfname    format  a75     heading 'Trace File Name';
column trcsess    format  a28     heading 'trcsess';

--	s.SQL_TRACE_PLAN_STATS,
--	'EXECUTE DBMS_MONITOR.SESSION_TRACE_ENABLE(session_id=>'||s.sid||',serial_num=>'||s.serial#||',waits=>TRUE,binds=>TRUE);' sqltraceon
--	s.server,
--	s.machine,
--	s.program,

select
	s.username,
	sid||'.'||s.serial# sess,
	p.spid,
	to_char(s.logon_time,'mm/dd/yy hh24:mi:ss') as logontime,
	case s.SQL_TRACE            when 'ENABLED' then 'Y' else 'N' end trenabled,
	case s.SQL_TRACE_WAITS      when 'TRUE'    then 'Y' else 'N' end waenabled,
	case s.SQL_TRACE_BINDS      when 'TRUE'    then 'Y' else 'N' end bienabled,
	case s.SQL_TRACE       when 'DISABLED' 
then  'EXEC DBMS_MONITOR.SESSION_TRACE_ENABLE(session_id=>'||sid||',serial_num=>'||s.serial#||',waits=>TRUE,binds=>TRUE);' 
else 'EXEC DBMS_MONITOR.SESSION_TRACE_DISABLE(session_id=>'||sid||',serial_num=>'||s.serial#||');' end command,
	i.host_name||':'||r.value ||'/'|| i.instance_name ||'_ora_'|| p.spid ||'.trc' trfname,
	'trcsess session='||sid||'.'||s.serial# trcsess
from gv$session s, gv$process p, gv$instance i, (select value from v$parameter where name = 'user_dump_dest') r
where s.inst_id = &&inst_id
and   s.sid     = &&sid
and   s.inst_id = p.inst_id(+)
and   s.paddr   = p.addr(+)
and   s.inst_id = i.inst_id;
