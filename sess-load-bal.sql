col machine format a48
select inst_id, count(*) from gv$session group by inst_id;


select inst_id, machine, count(*) from gv$session group by inst_id, machine order by inst_id, count(*) desc;


select inst_id, username, count(*) from gv$session group by inst_id, username order by inst_id, count(*) desc;
