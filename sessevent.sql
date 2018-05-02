column event      format a50 heading 'Event Name';
column wait_class format a30 heading 'Wait|Class';

column inst_id        heading 'Inst|ID';
column total_waits    heading 'Total|Waits';
column total_timeouts heading 'Total|TmOut';
column time_waited    format 999990.000000 heading 'Time|Waited (s)';
column average_wait   heading 'Average|Wait(s)';
column max_wait       heading 'Max|Wait(s)';


break on report;
compute sum of time_waited on report;

select
	inst_id,
	sid,
	event,
	total_waits,
	total_timeouts,
	(time_waited_micro/1000000) time_waited,
	(average_wait/100) average_wait,
	(max_wait/100) max_wait,
	wait_class
from gv$session_event
where inst_id = &&inst_id
and sid = &&sid
order by time_waited_micro desc;
