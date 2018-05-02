col description format a24;
col default_value format a12;
col display_value format a12;
col update_comment format a8;
col value format a22;
col name format a12;

col name                 format a22
col audit_sys_operations format a22
col audit_syslog_level   format a22

--select * from v$parameter where name = 'audit_trail';
--select * from v$parameter where name='audit_sys_operations';

select 
	to_char(sysdate,'mm/dd/yyyy hh24:mi:ss') now
	,(select name from v$database) DB
	,(select value from v$parameter where name = 'audit_sys_operations') audit_sys_operations
	,(select value from v$parameter where name = 'audit_syslog_level') audit_syslog_level
from dual;
