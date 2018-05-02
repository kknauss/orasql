column host_name format a22;
column instance_name format a22;
column user format a22;

--select user, instance_name, host_name from v$instance;

select USER, sys_context('USERENV', 'INSTANCE_NAME') instance_name, sys_context('USERENV', 'SERVER_HOST') host_name from dual;

@now
