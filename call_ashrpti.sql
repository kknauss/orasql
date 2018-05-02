set linesize 180;
set pagesize 255;


column db_name new_value dbName;
column db_id   new_value dbId;
column sw new_value slot_width noprint;
column report_name new_value report_name noprint;

select dbid db_id, name db_name from v$database;
select distinct instance_number, instance_name, host_name from dba_hist_database_instance order by instance_number, instance_name;
select 5 * 60 sw from dual;


define  inst_num     =    &instid ;
prompt begin_time is in format 'MM/DD/YY HH24:MI';
define  begin_time = '&begin_time';
define  duration = 60 ;
define  report_type  =      'html';
define  dbid         =      &dbId ;
define  target_session_id = '';
define  target_service_hash = '';
define  target_sql_id = '&sqlid';
define  target_client_id = '';
define  target_wait_class = '';
define  target_module_name = '';
define  target_action_name = '';


select 'ashrpt_' || &inst_num || '_' || to_char(to_date('&begin_time','mm/dd/yy hh24:mi') + (&duration / (24*60)), 'mmdd_hh24mi') || '.&dbName..&report_type' report_name from sys.dual;


exec dbaudit.set_dba_role('');
@@?/rdbms/admin/ashrpti
exec dbaudit.unset_dba_role();


undefine  inst_num
undefine  dbid
undefine  report_type
undefine  begin_time
undefine  duration
undefine  slot_width
undefine  target_session_id
undefine  target_service_hash
undefine  target_sql_id
undefine  target_client_id
undefine  target_wait_class
undefine  target_module_name
undefine  target_action_name
