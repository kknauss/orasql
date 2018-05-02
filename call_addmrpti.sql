set linesize 180;
set pagesize 255;

column begin_interval_time format a19;
column end_interval_time   format a19;

select snap_id, to_char(begin_interval_time,'yyyy-mm-dd hh24:mi') begin_interval_time, to_char(end_interval_time,'yyyy-mm-dd hh24:mi') end_interval_time
from dba_hist_snapshot
where instance_number = 1
and trunc(end_interval_time,'DD') >= trunc(sysdate-&&nbrDays,'DD')
and extract(hour from end_interval_time) between '&&begHour' and '&&endHour'
order by snap_id desc;

column db_name new_value dbName;
column db_id   new_value dbId;
select dbid db_id, name db_name from v$database;

select distinct instance_number, instance_name, host_name from dba_hist_database_instance order by instance_number, instance_name;


define  inst_num     =    &instid ;
define  begin_snap   =   &&begSnap ;
define  end_snap     =   &&endSnap ;

define  db_name      =   '&dbName';
define  dbid         =      &dbId ;
define  num_days     =          0 ;

column report_name new_value report_name noprint;

select 'addmrpt_' || &inst_num || '_' || '&&begin_snap' || '_' || '&&end_snap' || '.&dbName..txt' report_name from sys.dual;


exec dbaudit.set_dba_role('');
@@?/rdbms/admin/addmrpti
exec dbaudit.unset_dba_role();

undefine  inst_num
undefine  inst_name
undefine  begin_snap
undefine  end_snap
undefine  num_days
undefine  db_name
undefine  dbid
