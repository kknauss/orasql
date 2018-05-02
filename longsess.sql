column ii          format 09 heading 'inst|id';
column sid         format 99999 heading 'sid';
column serial#     format 99999 heading 'serial#';
column opname      format a34 heading 'operation';
column target      format a35 heading 'target';
column username    format a18 heading 'username';
column event       format a28;
column elap_remain format a12 heading 'elapsed/|remain';
column machine     format a24;
column sofar       format 999999999 heading 'blocks|processed';
column totalwork   format 999999999 heading 'total|blocks';
column pctdone     format 990.99 heading '%|complete';
column spid        format a7 heading 'server|pid';
column elapsed     format a11 heading '   elapsed| hhh:mm:ss';
column remaining   format a11 heading '    remain| hhh:mm:ss';


ttitle 'Session Information ...' LEFT skip 2

select a.inst_id ii, a.sid, a.serial#, c.spid, a.username, a.server, a.machine, a.status, a.event
  from gv$session a, gv$process c
 where exists (
			select 1
			from gv$session_longops lo
			where time_remaining > 0
			and lo.sid = a.sid
			and lo.inst_id = a.inst_id
		)
   and a.inst_id = c.inst_id
   and a.paddr = c.addr
order by a.inst_id, a.sid;

ttitle off;
