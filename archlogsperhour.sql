alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';

column mb format 9999999.99


  select to_char(trunc(COMPLETION_TIME, 'HH24'), 'Day yyyy-mm-dd hh24:mi') as tmsp, count(*) as nbrlogs, sum(((blocks+1)*block_size))/(1024*1024) mb
    from v$archived_log
  where dest_id = 1
     and trunc(COMPLETION_TIME, 'HH24') >= trunc(sysdate-7, 'HH24')
     and trunc(COMPLETION_TIME, 'HH24') <  trunc(sysdate,   'HH24')
group by trunc(COMPLETION_TIME, 'HH24')
order by trunc(COMPLETION_TIME, 'HH24');
