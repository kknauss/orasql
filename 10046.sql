
-- set timed statistics at user session level if not set at system level.
execute sys.dbms_system.set_boo_param_in_session(&&SID, &&SERIAL,'timed_statistics',true); 

--set max dump file size if not set at system level.
execute sys.dbms_system.set_in_param_in_session (&&SID, &&SERIAL, 'max_dump_file_size',10000000); 

-- activate level 8 extended SQL tracing.
execute sys.dbms_system.set_ev(&&SID, &&SERIAL, 10046, 8, ' '); 

******* run all of your processing here *******

-- disables extended SQL tracing.
execute sys.dbms_system.set_ev(&&SID, &&SERIAL, 10046, 0, ' '); 


/*
 * alter session set events '10046 trace name context forever, level N';
 *
 * Where N is:
 *
 *  1 = normal set sql_trace=true
 *  4 = include values of bind variables
 *  8 = include wait events
 * 12 = include values of bind variables and wait events
 *

select i.instance_name ||'_ora_'|| p.spid ||'.trc' as "Trace file name"
from v$process p, v$session s, v$instance i
where s.sid = (select sid from v$mystat where rownum = 1)
and s.paddr = p.addr;
*/
