col log_user format a18;
col what format a68;
col job_name format a32;
col program_name format a32;
col last_run_duration format a32;
col elapsed_time format a18;

select r.sid, j.log_user, j.job, j.what, r.instance, r.this_date start_time
from dba_jobs_running r, dba_jobs j
where j.job = r.job;

select owner, job_name, job_subname, session_id, slave_process_id, slave_os_process_id, running_instance, elapsed_time 
from dba_scheduler_running_jobs
order by elapsed_time desC;

/*
select owner, job_name, state, 
to_char(last_start_date,'mm/dd/yyyy hh24:mi:ss') last_start_date, last_run_duration,
program_name
--to_char(next_start_date,'mm/dd/yyyy hh24:mi:ss') next_run_date
from dba_scheduler_jobs;
*/
