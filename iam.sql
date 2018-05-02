set appinfo on;
column i_am new_value iam;

set termout off;
select substr(whoami,instr(whoami,' ')+1) i_am from (select sys_context('USERENV', 'MODULE') whoami from dual);
set termout on;

prompt Spooling to:  &iam..lst
spool &iam..lst;
