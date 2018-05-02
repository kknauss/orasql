column holder             format    a18 heading 'Holder Username';
column holder_inst        format     09 heading 'Holder|Inst ID';
column holder_sid         format 999999 heading 'Holder|SID';
column holder_serial#     format 999999 heading 'Holder|Serial#';
column holder_grant_time  format 999999 heading 'Holder|Grant|Time (s)';
column holder_lmode                     heading 'Holder|Lock Mode';
column holder_machine     format    a24 heading 'Holder|Machine';
column holder_lock_type   format    a20 heading 'Holder|Lock|Type';
column killcmd            format    a55 heading 'Kill Command (sid,serial#,inst)';

column waiter             format    a18 heading 'Waiter Username';
column waiter_inst        format     09 heading 'Waiter|Inst ID';
column waiter_sid         format 999999 heading 'Waiter|SID';
column waiter_lmode                     heading 'Waiter|Requested|Lock Mode';
column waiter_grant_time  format 999999 heading 'Waiter|Grant|Time (s)';
column waiter_machine     format    a24 heading 'Waiter|Machine';

select
c.prev_sql_id,
	c.username holder,
	c.machine holder_machine,
--	a.inst_id holder_inst,
--	a.sid holder_sid,
--	c.serial# holder_serial#,
	'alter system kill session '''|| a.sid ||','|| c.serial# ||',@'|| a.inst_id ||''' immediate;' KILLCMD,
	a.ctime holder_grant_time,
	case a.type 
		when 'TX' then 'TX - TransX enqueue'
		when 'TM' then 'TM - DML enqueu'
		when 'UL' then 'UL - User supplied'
		else 'System: '||a.type
	end holder_lock_type,
	case a.lmode 
		when 0 then '0 - none'
		when 1 then '1 - null (NULL)'
		when 2 then '2 - row-S (SS)'
		when 3 then '3 - row-X (SX)'
		when 4 then '4 - share (S)'
		when 5 then '5 - S/Row-X (SSX)'
		when 6 then '6 - exclusive (X)'
		else ' '
	end holder_lmode,
	d.username waiter,
	d.machine waiter_machine,
	d.sql_id waiter_sqlid,
	b.inst_id waiter_inst,
	b.sid waiter_sid,
	b.ctime waiter_grant_time,
	case b.request
		when 0 then '0 - none'
		when 1 then '1 - null (NULL)'
		when 2 then '2 - row-S (SS)'
		when 3 then '3 - row-X (SX)'
		when 4 then '4 - share (S)'
		when 5 then '5 - S/Row-X (SSX)'
		when 6 then '6 - exclusive (X)'
		else ' '
	end waiter_lmode
from 
    (select inst_id, sid, type, id1, ctime, lmode from gv$lock where block > 0) a,
    (select inst_id, sid, type, id1, ctime, request from gv$lock where request > 0) b, 
    gv$session c,
    gv$session d
where a.ID1 = b.ID1
  and a.inst_id = c.inst_id
  and a.sid = c.sid
  and b.inst_id = d.inst_id
  and b.sid = d.sid
order by a.ctime desc, waiter_grant_time desc;
