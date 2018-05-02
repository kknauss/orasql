select
     trunc(s.BEGIN_INTERVAL_TIME, 'DD') SAMPLE_DATE
    ,round(sum(sql.ELAPSED_TIME_DELTA) /1000000,2) elap_time_sec
    ,round(sum(sql.CPU_TIME_DELTA)     /1000000,2) cpu_time_sec
    ,round(
            sum(sql.CPU_TIME_DELTA/1000000) / sum(sql.ELAPSED_TIME_DELTA/1000000)
         ,4) * 100 cpu_pct 
    ,count(distinct s.SNAP_ID) nbr_samples
    ,min(s.SNAP_ID) begin_snap
    ,max(s.SNAP_ID) end_snap
from
    DBA_HIST_SQLSTAT sql,
    DBA_HIST_SNAPSHOT s
where
    sql.SNAP_ID = s.SNAP_ID
and sql.INSTANCE_NUMBER = s.INSTANCE_NUMBER
and sql.DBID = s.DBID
and s.BEGIN_INTERVAL_TIME >= trunc(sysdate-7,'DD') 
and s.END_INTERVAL_TIME   <= trunc(sysdate+1,'DD')
and extract(hour from s.BEGIN_INTERVAL_TIME) between 00 and 06
and extract(hour from s.END_INTERVAL_TIME)   between 00 and 06
group by
    trunc(s.BEGIN_INTERVAL_TIME, 'DD')
order by
    cpu_pct desc;
