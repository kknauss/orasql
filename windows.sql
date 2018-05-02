col schedule_owner format a18;
col repeat_interval format a80;
col duration format a32;
select schedule_owner, window_name, resource_plan, active, enabled, repeat_interval, duration from dba_scheduler_windows;
