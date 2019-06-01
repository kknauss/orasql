SET SERVEROUTPUT ON ;

col machine format a24;

select inst_id, case when instr(machine,'.') > 0 then substr(machine,1,instr(machine,'.')-1) else machine end machine, count(*)
from gv$session
where 1=1
group by inst_id, machine 
order by inst_id, machine, count(*) desc;

/* ***
select inst_id, case when instr(machine,'.') > 0 then substr(machine,1,instr(machine,'.')-1) else machine end machine, count(*)
from gv$session
where 1=1
and
(
	machine like '%util%'
	or  machine like '%mismo%'
	or  machine like '%proc%'
	or  machine like '%app%'
	or  machine like '%obie%'
	or  machine like '%imgce%'
	or  machine like '%FSTROY%'
--	or  REGEXP_LIKE (machine, '*0[1-9]$')
)
group by inst_id, machine 
order by inst_id, machine, count(*) desc;
* ***/


@inst


DECLARE
  sep varchar2(1) := ',';
  ret varchar2(4000) := '';
  TYPE cur_typ IS REF CURSOR;
  rec cur_typ;
  field varchar2(4000);
  sqlstr varchar2(4000) := q'[select distinct case when instr(machine,'.') > 0 then substr(machine,1,instr(machine,'.')-1) else machine end machine
	from v$session
	where 1=1
	and
	(
	machine like '%util%'
      	or  machine like '%mismo%'
      	or  machine like '%proc%'
      	or  machine like '%app%'
      	or  machine like '%obie%'
      	or  machine like '%imgce%'
      	or  machine like '%FSTROY%'
	)
	group by machine 
	order by machine, count(*) desc]';
begin
     OPEN rec FOR sqlstr;
     LOOP
         FETCH rec INTO field;
         EXIT WHEN rec%NOTFOUND;
         ret := ret || field || sep;
     END LOOP;
     
     dbms_output.put_line(substr(ret,1,length(ret)-length(sep)));
end;
/

exit 0;
