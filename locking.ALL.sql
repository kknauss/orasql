/**********
select c.username ||' ('||a.sid||') is holding a lock ' || d.username ||' ('||b.sid||') is waiting for.'
from v$lock a, v$lock b, v$session c, v$session d
where a.BLOCK > 0
   and b.REQUEST > 0 
   and a.ID1 = b.ID1
   and a.sid = c.sid
   and b.sid = d.sid ;
**********/

--This seems a bit faster...   
select c.username ||'('||a.sid||') is holding a lock ' || d.username ||'('||b.sid||') is waiting for.'
from (select sid, id1 from v$lock where block > 0) a,
        (select sid, id1 from v$lock where request > 0) b, 
		v$session c, v$session d
where a.ID1 = b.ID1
   and a.sid = c.sid
   and b.sid = d.sid ;

/*
-- for object (latch waits??)....
-- getting ORA-04021: timeout occurred while waiting to lock object?
select * FROM v$access WHERE object = '<pkg/procedurename>';
*/

              
select s.*
from gv$session s,
 (
                select inst_id, sid
                from gv$access
                where object = 'LOAN_END_STATE'
              ) a
where s.inst_id = a.inst_id
and s.sid = a.sid
and s.status <> 'INACTIVE';
              
--         316932
--              316932
select *
from dba_objects
where owner = 'KKNAUSS'
and object_name = 'KEITH';

select inst_id, sid FROM gv$access WHERE object = 'PKG_DM_MTG_PRODUCT';

--RACified... this is not tested yet   
select c.username ||'('||a.inst_id||','||a.sid||') is holding a lock ['||a.ctime||'] ' || d.username ||'('||b.inst_id||','||b.sid||') is waiting for.' as whos_blocking_who
from 
    (select inst_id, sid, id1, ctime from gv$lock where block > 0) a,
    (select inst_id, sid, id1, ctime from gv$lock where request > 0) b, 
    gv$session c,
    gv$session d
where a.ID1 = b.ID1
  and a.inst_id = c.inst_id
  and a.sid = c.sid
  and b.inst_id = d.inst_id
  and b.sid = d.sid ;

select c.username holder, a.inst_id holder_inst, a.sid holder_sid, a.ctime holder_grant_time, d.username waiter, b.inst_id waiter_inst, b.sid waiter_sid
from 
    (select inst_id, sid, id1, ctime from gv$lock where block > 0) a,
    (select inst_id, sid, id1, ctime from gv$lock where request > 0) b, 
    gv$session c,
    gv$session d
where a.ID1 = b.ID1
  and a.inst_id = c.inst_id
  and a.sid = c.sid
  and b.inst_id = d.inst_id
  and b.sid = d.sid
order by a.ctime desc;


--select * from v$lock where lmode = 6;
--select * from v$lock;
--select * from v$locked_object   ;
--select * from dba_objects where DATA_OBJECT_ID = 1;
