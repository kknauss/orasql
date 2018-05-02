column event      format a36 heading 'Event Name';
column wait_class format a30 heading 'Wait|Class';

select *
from v$system_event
--where wait_class != 'Idle'
where wait_class = 'Commit'
order by time_waited desc;
