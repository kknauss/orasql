column inst_id      format       9    heading 'In|st';
column sid          format  999999; 
column owner        format     a24;
column object       format     a32;
column type         format     a18;
column username     format  a20    heading 'Username';
column status       format   a12    heading 'St|at|us';
column serial#      format  999999 heading 'Serial#';

/*
select inst_id, sid from gv$access where object = upper('&&obj');

*/

select s.inst_id, s.sid, s.serial#, s.username, s.status
from gv$session s, gv$access a
where s.inst_id = a.inst_id
and s.sid = a.sid
and a.object = upper('&&obj') ;
