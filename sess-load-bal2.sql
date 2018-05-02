col machine format a48

select inst_id, count(*) from gv$session group by inst_id order by inst_id;

select machine, count(*) from gv$session 
where lower(machine) like 'whapp%' 
or    lower(machine) like 'beaapp%' 
group by machine order by machine;

select inst_id, machine, count(*) from gv$session 
where lower(machine) like 'whapp%' 
or    lower(machine) like 'beaapp%' 
group by inst_id , machine order by inst_id, machine;

--select inst_id, machine, count(*) from gv$session where lower(machine) like 'whapp%' group by inst_id, machine order by machine, inst_id, count(*) desc;

/*
select inst_id, username, count(*) from gv$session 
where lower(machine) like 'whapp%' 
or    lower(machine) like 'beaapp%' 
group by inst_id, username order by inst_id, username, count(*) desc;
*/
