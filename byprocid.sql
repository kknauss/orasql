select  a.inst_id, a.spid, a.username, b.username, b.sid, b.serial#, a.PGA_USED_MEM, a.PGA_ALLOC_MEM, a.PGA_FREEABLE_MEM, a.PGA_MAX_MEM
from gv$process a, gv$session b
where a.spid = '&spid'
and a.addr = b.paddr
and a.inst_id = b.inst_id;

