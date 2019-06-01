BREAK ON REPORT SKIP 1;
COMPUTE SUM LABEL 'TOTAL' OF ublk_MB ON REPORT;

select s.inst_id, s.sid, s.username, s.program, s.machine, t.addr, t.xidusn, t.used_urec, t.USED_UBLK, ((t.USED_UBLK * (select value from v$parameter where name = 'db_block_size'))/(1024*1024)) as ublk_MB
from gv$transaction t, gv$session s
where s.inst_id = t.inst_id
and s.taddr = t.addr
order by s.inst_id, s.sid;
