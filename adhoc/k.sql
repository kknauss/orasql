spool k.log;


--select instance_name, x.thread#, max(nbr_logs) max_nbr_logs, max(est_size_mb) max_daily_change_MB
select instance_name, max(est_size_mb) max_daily_change_MB
from
(
      select trunc(first_time, 'DD') as activty_dt, thread#, count(*) as nbr_logs, ( count(*) * (select max(bytes) from v$log))/(1024*1024) as est_size_mb
        from v$log_history
       where trunc(first_time, 'DD') >= trunc(sysdate-180, 'DD')
         and trunc(first_time, 'DD') <  trunc(sysdate,   'DD')
    group by trunc(first_time, 'DD'), thread#
) x,
gv$instance i
where x.thread# = i.thread#(+)
group by instance_name, x.thread#
order by x.thread#;

select instance_name from gv$instance;

/*

  select trunc(first_time, 'DD') as activty_dt, thread#, count(*) as nbr_logs, ( count(*) * (select max(bytes) from v$log))/(1024*1024) as est_size_mb
    from v$log_history
   where trunc(first_time, 'DD') >= trunc(sysdate-180, 'DD')
     and trunc(first_time, 'DD') <  trunc(sysdate,   'DD')
group by trunc(first_time, 'DD'), thread#
order by trunc(first_time, 'DD') DESC, thread#;
*/


spool off;
exit;
