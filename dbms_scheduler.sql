/* *****************************************
select * from DBA_SCHEDULER_JOBS;
select * from DBA_SCHEDULER_PROGRAMS;
select * from DBA_SCHEDULER_WINDOW_DETAILS;

select * from DBA_SCHEDULER_JOB_LOG where JOB_NAME = 'GATHER_STATS_JOB' order by LOG_DATE desc;

select * from DBA_SCHEDULER_WINDOW_LOG order by LOG_DATE desc;
select * from DBA_SCHEDULER_JOB_RUN_DETAILS;
***************************************** */

set linesize 132;
column additional_info format a18;
select log_date, operation, additional_info from DBA_SCHEDULER_JOB_LOG where JOB_NAME = 'GATHER_STATS_JOB' order by log_date desc;

/* *****************************************
DBA_SCHEDULER_CHAIN_RULES
DBA_SCHEDULER_CHAIN_STEPS
DBA_SCHEDULER_CHAINS
DBA_SCHEDULER_GLOBAL_ATTRIBUTE
DBA_SCHEDULER_JOB_ARGS
DBA_SCHEDULER_JOB_CLASSES
DBA_SCHEDULER_JOB_LOG
DBA_SCHEDULER_JOB_RUN_DETAILS
DBA_SCHEDULER_JOBS
DBA_SCHEDULER_PROGRAM_ARGS
DBA_SCHEDULER_PROGRAMS
DBA_SCHEDULER_RUNNING_CHAINS
DBA_SCHEDULER_RUNNING_JOBS
DBA_SCHEDULER_SCHEDULES
DBA_SCHEDULER_WINDOW_DETAILS
DBA_SCHEDULER_WINDOW_GROUPS
DBA_SCHEDULER_WINDOW_LOG
DBA_SCHEDULER_WINDOWS
DBA_SCHEDULER_WINGROUP_MEMBERS


select * from dba_objects where OBJECT_ID = 130767;

***************************************** */