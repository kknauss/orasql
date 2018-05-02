/*
 * This query is intended to be matched up (or able to be matched up) to a set of AWR reports.
 * Since AWR uses a value's difference between a set of snapshots (using cumulative values),
 * and since this query uses the delta values across a snapshots, we do not include
 * the beginning snapshot... only snapshots greater than it.
*/

set pagesize 1024;
set linesize  255;
set verify off;


column begin_interval_time format a19;
column end_interval_time   format a19;

/*
select snap_id, to_char(begin_interval_time,'yyyy-mm-dd hh24:mi') begin_interval_time, to_char(end_interval_time,'yyyy-mm-dd hh24:mi') end_interval_time
from dba_hist_snapshot
where instance_number = 1
and trunc(end_interval_time,'DD') >= trunc(sysdate-&&nbrDays,'DD')
and extract(hour from end_interval_time) between '&&begHour' and '&&endHour'
order by snap_id desc;
*/


column executions                     heading "Executions";
column elap_per_exec format 999990.99 heading "Elapsed Time|Per|Execution(s)";
column elap_time_sec format 999990.99 heading "Elapsed|Time(s)";
column cpu_time_sec  format 999990.99 heading "CPU|Time(s)";
column cpu_pct       format    990.99 heading "CPU|%";
column module        format a32       heading "Program";
column sql_text                       heading "SQL Statement";

column report_name new_value report_name noprint;

select 'wklycpu_' || '&&begSnap' || '_' || '&&endSnap' || '.&dbName..lst' report_name from sys.dual;

ttitle 'Top 20 CPU Queries (&&begSnap to &&endSnap) ...' LEFT skip 2

spool &report_name;

select * from 
(
	select 
		a.executions,
		case when a.executions > 0 then 
			round(a.elap_time_sec / a.executions,2) 
		else
			null
		end as elap_per_exec,
		a.module,
		a.elap_time_sec,
		a.cpu_time_sec,
		case when a.elap_time_sec > 0 then 
			round( (a.cpu_time_sec / a.elap_time_sec)*100,2)
		else
			null
		end cpu_pct,
		st.sql_id,
		st.sql_text
	from
	(
        	select
            	sql.SQL_ID
           	,max(sql.MODULE) module
           	,round(sum(sql.ELAPSED_TIME_DELTA) /1000000,2) elap_time_sec
           	,round(sum(sql.CPU_TIME_DELTA)     /1000000,2) cpu_time_sec
           	,sum(sql.EXECUTIONS_DELTA) executions
           	,count(*) nbr_samples
        	from        DBA_HIST_SQLSTAT sql, 
                    	DBA_HIST_SNAPSHOT s
        	where       sql.SNAP_ID = s.SNAP_ID
        	and         sql.INSTANCE_NUMBER = s.INSTANCE_NUMBER
        	and         sql.DBID = s.DBID
        	and         s.snap_id  > &&begSnap
		and         s.snap_id <= &&endSnap
        	group by    sql.SQL_ID
		order by cpu_time_sec desc
	) a, DBA_HIST_SQLTEXT st
	where a.sql_id = st.sql_id
	order by cpu_time_sec desc
)
where rownum < 21;

spool off;
set verify on;
ttitle off;

undef begSnap
undef endSnap
