col job       heading 'Job #';
col log_user  heading 'User Login';
col next_date heading 'Next Exec Date' format a22;
col last_date heading 'Last Exec Date' format a22;
col this_date heading 'Job Start Date' format a22;
col what format a80 heading 'Job';

select job, log_user, broken, to_char(next_date,'mm/dd/yyyy hh24:mi:ss') next_date,  total_time,
to_char(last_date,'mm/dd/yyyy hh24:mi:ss') last_date, 
to_char(this_date,'mm/dd/yyyy hh24:mi:ss') this_date, what
from dba_jobs
order by log_user, what ;
--order by log_user, job;

col job_name format a32;
col program_name format a32;
col last_run_duration format a32;

select owner, job_name, state, 
to_char(last_start_date,'mm/dd/yyyy hh24:mi:ss') last_start_date, last_run_duration,
program_name
,to_char(NEXT_RUN_DATE,'mm/dd/yyyy hh24:mi:ss') next_run_date
from dba_scheduler_jobs
order by owner, job_name;
