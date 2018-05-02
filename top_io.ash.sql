--http://www.oracle.com/technology/products/manageability/database/pdf/twp03/PPT_active_session_history.pdf
--page 25
--Returns SQL spending most time doing I/Os
--Similarly, can do Top Sessions, Top Files, Top Objects

select ash.sql_id, count(*)
from v$active_session_history ash, v$event_name evt
where ash.sample_time > sysdate - 1/24/60
--where ash.sample_time > sysdate - 1/24
and ash.session_state = 'WAITING'
and ash.event_id = evt.event_id
and evt.wait_class = 'User I/O'
group by sql_id 
order by count(*) desc;
