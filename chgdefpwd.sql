--
-- https://oraganism.wordpress.com/tag/password/
--
set serveroutput on;

begin
	for i in
		(
			select 'alter user '||u.username||' identified by ' ||dbms_random.string('a', 10)||'_'||trunc(dbms_random.value(1,99)) cmd , username
			from sys.dba_users_with_defpwd u
			where username <> 'XS$NULL'
--and username <> 'SYS'
			order by username
		)
	loop
		dbms_output.put_line('Securing '||i.username||'...');
		execute immediate i.cmd;
--		dbms_output.put_line(i.cmd ||';');
	end loop;
end;
/
