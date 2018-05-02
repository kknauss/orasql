set verify off;

column category       format 9999999.99 heading 'PGA Category';
column allocated      format 9999999.99 heading 'Alloc (KB)';
column used           format 9999999.99 heading 'Used (KB)';
column max_allocated  format 9999999.99 heading 'Max Alloc (KB)';

select b.category, round(b.allocated/1024,2) allocated, round(b.used/1024,2) used, round(b.max_allocated/1024,2) max_allocated
from gv$session a, gv$process_memory b, gv$process c
where 1=1
and a.inst_id    = c.inst_id(+)
and a.paddr      = c.addr(+)
and c.inst_id    = b.inst_id
and c.pid        = b.pid
and c.serial#    = b.serial#
and a.inst_id    = &&inst_id
and a.sid        = &&sid
order by category;
