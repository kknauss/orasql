select s.inst_id, s.sid, t.addr, t.used_urec, t.USED_UBLK, round(((t.USED_UBLK * (select value from v$parameter where name = 'db_block_size'))/(1024*1024)),2) as ublk_MB
from gv$transaction t, gv$session s
where s.inst_id = t.inst_id
and s.taddr = t.addr
and s.inst_id = &&inst_id
and s.sid = &&sid
order by s.inst_id, s.sid;
