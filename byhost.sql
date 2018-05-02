compute sum of count(*) on report;
column program format a42;
column osuser format a22;
column username format a20;
column machine format a32;
column II format 09;


compute sum of nbr_conn on report;
break on report;

select inst_id, username, machine, osuser, program, server, count(*) nbr_conn, min(LOGON_TIME) first_conn_time, max(LOGON_TIME) last_conn_time
from gv$session
where lower(machine) like lower('%&&hostnm%')
group by inst_id, machine, osuser, program, server, username
order by          machine, osuser, program, server, username, inst_id;

select machine, inst_id, count(*) nbr_conn
from gv$session
where lower(machine) like lower('%&&hostnm%')
group by inst_id, machine
order by machine, inst_id;

select inst_id, count(*) nbr_conn
from gv$session
where lower(machine) like lower('%&&hostnm%')
group by inst_id
order by inst_id;
