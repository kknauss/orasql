--select * from gv$ges_blocking_enqueue;

select inst_id, pid, transaction_id0, transaction_id1, which_queue, state, blocked, blocker, resource_name1 
from gv$ges_blocking_enqueue 
order by resource_name1, blocker desc, blocked;
