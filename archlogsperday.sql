alter session set nls_date_format = 'mm/dd/yyyy';

select trunc(sysdate, 'dd') from dual;

column mb format 9999999.09

  select to_char(trunc(COMPLETION_TIME, 'DD'), 'Day yyyy-mm-dd') as tmsp, count(*) as nbrlogs, round(sum(((blocks+1)*block_size))/(1024*1024*1024),2) gb
    from v$archived_log
  where dest_id = 1
     and trunc(COMPLETION_TIME, 'DD') >= trunc(sysdate-30, 'DD')
--   and trunc(COMPLETION_TIME, 'DD') <  trunc(sysdate,   'DD')
group by trunc(COMPLETION_TIME, 'DD')
order by trunc(COMPLETION_TIME, 'DD');


/* *********************
alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';
select trunc(sysdate, 'hh24'),trunc(sysdate-2, 'hh24') from dual;

  select to_char(trunc(first_time, 'HH24'), 'yyyy-mm-dd hh24:mi') as activty_dt, count(*) as nbr_logs, ( count(*) * (select max(bytes) from v$log))/(1024*1024) as est_size_mb
    from v$archived_log
   where trunc(first_time, 'HH24') >= trunc(sysdate-1, 'HH24')
     and trunc(first_time, 'HH24') <  trunc(sysdate,   'HH24')
group by trunc(first_time, 'HH24')
order by trunc(first_time, 'HH24');

select 
  recid, 
  name, 
  thread#, sequence#,
--first_time,
--next_time, 
  COMPLETION_TIME, 
  ((blocks+1)*block_size) sizeBytes 
from v$archived_log 
where dest_id = 1 
order by recid desc;

alter session set nls_date_format = 'mm/dd/yyyy';
select trunc(sysdate, 'dd') from dual;

  select to_char(trunc(COMPLETION_TIME, 'DD'), 'Day yyyy-mm-dd') as tmsp, count(*) as nbrlogs, sum(((blocks+1)*block_size)) bytes
    from v$archived_log
  where dest_id = 1
     and trunc(COMPLETION_TIME, 'DD') >= trunc(sysdate-7, 'DD')
     and trunc(COMPLETION_TIME, 'DD') <  trunc(sysdate,   'DD')
group by trunc(COMPLETION_TIME, 'DD')
order by trunc(COMPLETION_TIME, 'DD');


WITH X AS (
              SELECT RECID, NAME, THREAD#, SEQUENCE#, FIRST_TIME, NEXT_TIME, COMPLETION_TIME, ((BLOCKS+1)*BLOCK_SIZE) SIZEBYTES 
              FROM V$ARCHIVED_LOG 
              WHERE DEST_ID = 1 
)
SELECT TO_CHAR(TRUNC(COMPLETION_TIME, 'DD'), 'Day yyyy-mm-dd') AS TMSP, COUNT(*) AS NBRLOGS, SUM(SIZEBYTES) BYTES, ROUND(SUM(SIZEBYTES)/(1024*1024*1024),2) SIZEGB
    FROM X
   WHERE TRUNC(COMPLETION_TIME, 'DD') >= TRUNC(SYSDATE-14, 'DD')
     AND TRUNC(COMPLETION_TIME, 'DD') <  TRUNC(SYSDATE,   'DD')
GROUP BY TRUNC(COMPLETION_TIME, 'DD')
ORDER BY TRUNC(COMPLETION_TIME, 'DD');
* ********************* */
