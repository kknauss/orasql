/*
 * This query is intended to be matched up (or able to be matched up) to a set of AWR reports.
 * Since AWR uses a value's difference between a set of snapshots (using cumulative values),
 * and since this query uses the delta values across a snapshots, we do not include
 * the beginning snapshot... only snapshots greater than it.
*/

set pagesize 0;
set linesize 4096;
set serveroutput on size 1000000;
set verify off;
set feedback off;

column line_item     format a180      heading "Pipe-delimited Line";
column report_name new_value report_name noprint;
column fromtime    new_value fromtime ;
column totime      new_value totime   ;
column saveas      new_value saveas   ;

select 'wklycpu_' || '&&begSnap' || '_' || '&&endSnap' || '.&dbName..txt' report_name from sys.dual;
select to_char(end_interval_time,'MM/DD/YYYY hh:mi AM') fromtime from dba_hist_snapshot where snap_id = &&begSnap;
select to_char(end_interval_time,'hh:mi AM') totime   from dba_hist_snapshot where snap_id = &&endSnap;
select &&top_nbr from sys.dual;

SELECT
'\\fstroyacs01\enterprisetech\DBA Group\Capacity_and_Performance_Monitoring\' ||
CASE '&dbName' WHEN 'BRAV' THEN 'Mortrac' WHEN 'CRM89PRD' THEN 'CRM' ELSE 'UNK' END  ||
'\Top_10_Reports\'||
TO_CHAR(TRUNC(END_INTERVAL_TIME, 'DAY'),'YYYY')||'\'||
CASE '&dbName' WHEN 'BRAV' THEN 'Mortrac' WHEN 'CRM89PRD' THEN 'CRM' ELSE 'UNK' END  ||
'TopSQL_WeekOf_'||
TO_CHAR(TRUNC(END_INTERVAL_TIME, 'DAY'),'YYYYMMDD')||
'.xlsx' saveas
FROM DBA_HIST_SNAPSHOT
WHERE SNAP_ID = &&begSnap;


ttitle 'Top &&top_nbr CPU Queries (&&begSnap to &&endSnap) ...' LEFT skip 2

spool &report_name;


declare
	l_exec		DBA_HIST_SQLSTAT.executions_delta%TYPE;
	l_elap_per	number;
	l_dbtime	number;
	l_module	DBA_HIST_SQLSTAT.module%TYPE;
	l_elap_sec	DBA_HIST_SQLSTAT.elapsed_time_delta%TYPE;
	l_cpu_sec	DBA_HIST_SQLSTAT.cpu_time_delta%TYPE;
	l_sqlid		DBA_HIST_SQLSTAT.SQL_ID%TYPE;
	l_sqltext	varchar(4096);

	cursor c2 (w2 varchar) is select sql_text from dba_hist_sqltext where sql_id = w2;
	cursor c1 is 
	select * from
	(
		select 
			executions,
			round(elap_time_sec/executions,2),
			executions * (round(elap_time_sec/executions,2)),
			elap_time_sec,
			module,
			sql_id
		from
		(
			select
				 case sum(sql.EXECUTIONS_DELTA) when 0 then 1 else sum(sql.EXECUTIONS_DELTA) end executions
				,max(sql.MODULE) module
				,round(sum(sql.ELAPSED_TIME_DELTA) /1000000,2) elap_time_sec
				,round(sum(sql.CPU_TIME_DELTA)     /1000000,2) cpu_time_sec
				,sql.SQL_ID
			from
				DBA_HIST_SQLSTAT sql, 
				DBA_HIST_SNAPSHOT s
			where
				sql.SNAP_ID = s.SNAP_ID
			and	sql.INSTANCE_NUMBER = s.INSTANCE_NUMBER
			and	sql.DBID = s.DBID
			and	s.snap_id  > &&begSnap
			and	s.snap_id <= &&endSnap
			group by
				sql.SQL_ID
		)
		order by cpu_time_sec desc
	) where rownum <=  &&top_nbr ;
begin
	dbms_output.put_line(	'Executions'				||'|'||
				'Elapsed Time per Exec (in secs)'	||'|'||
				'DB Time (A*B)'				||'|'||
				'Program'				||'|'||
				'SQL Statement'   );
	open c1;
	loop
		fetch c1 into l_exec, l_elap_per, l_dbtime, l_elap_sec,	l_module, l_sqlid;
		exit when c1%NOTFOUND;
		if (l_dbtime < 0.01) then
			l_dbtime := l_elap_sec;
		end if;
		open c2 (l_sqlid);
		fetch c2 into l_sqltext;
		close c2;
		dbms_output.put_line(	l_exec				||'|'||
					l_elap_per			||'|'||
					l_dbtime			||'|'||
					l_module			||'|'||
					l_sqltext   );
	end loop;
	close c1;
	dbms_output.put_line(	'Top queries based on interval from &&fromtime to &&totime..');
	dbms_output.put_line(	'Save as: &&saveas');
end;
/

spool off;
set verify on;
set feedback on;
