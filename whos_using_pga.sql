column ii              format    09   heading 'Inst|ID';
column sid             format 99999;
column serial#         format 99999   heading 'Serial#';
column sql_text        format   a65   heading 'SQL Text';
column username        format   a24   heading 'Username';
column program         format   a24   heading 'Program';
column last_call_et                   heading 'Last Call|Elap(sec)';
column event           format   a48   heading 'Wait Event';
column pga_used_mb     format 99990.99 heading 'PGA Used|(MB)';
column pga_alloc_mb    format 99990.99 heading 'PGA Alloc|(MB)';
column pga_freeable_mb format 99990.99 heading 'PGA Freeb|(MB)';
column pga_max_mb      format 99990.99 heading 'PGA Max|Used (MB)';


--http://www-03.ibm.com/servers/enable/site/peducation/wp/a696/page_2.html
--select * from v$sga;
--select * from v$sgastat;
--select * from v$sgainfo;
--select * from v$pgastat;
--select round(pga_target_for_estimate/1024/1024) as target_size_MB, bytes_processed,estd_extra_bytes_rw as est_rw_extra_bytes, estd_pga_cache_hit_percentage as est_hit_pct, estd_overalloc_count as est_overalloc from v$pga_target_advice;
--select name,value from v$sysstat where name like 'workarea executions%';
--select * from v$process_memory;

ttitle left 'Top 20 PGA users... ';
SELECT *
FROM
(
	SELECT s.username, s.sid, s.serial#, s.status, s.last_call_et, s.event, p.spid, p.program, 
		round((p.pga_used_mem/(1024*1024)),2)     pga_used_mb, 
		round((p.pga_alloc_mem/(1024*1024)),2)    pga_alloc_mb, 
		round((p.pga_freeable_mem/(1024*1024)),2) pga_freeable_mb, 
		round((p.pga_max_mem/(1024*1024)),2)      pga_max_mb
	FROM v$process p, v$session s
	WHERE p.addr = s.paddr
	ORDER BY pga_used_mem DESC

	--	SELECT s.username, s.sid, s.serial#, p.spid, p.program, p.pga_used_mem, p.pga_alloc_mem, p.pga_freeable_mem, p.pga_max_mem, a.sql_text 
	--	FROM v$process p, v$session s, v$sqlarea a
	--	WHERE p.addr = s.paddr
	--	AND s.sql_hash_value = a.hash_value(+)
	--	AND s.sql_address = a.address(+)
	--	ORDER BY pga_used_mem DESC

)
WHERE ROWNUM < 21;

ttitle off;

column value format 999999999999;
select * from v$pgastat;
