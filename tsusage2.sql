column tablespace_name format a32;
column UsedMb      format  999990.99 ;
column FreeMb      format  999990.99 ;
column UsedPct     format a8;
column FreePct     format a8;

select
	b.tablespace_name,
	b.tbs_size SizeMb,
	a.free_space FreeMb,
	(b.tbs_size-a.free_space) UsedMB, 
	lpad(to_char(round(((a.free_space / b.tbs_size) *100),2), '999.99')||'%',8) FreePct,
	lpad(to_char(round((((tbs_size-a.free_space) / tbs_size) *100),2), '999.99')||'%',8) UsedPct
from 
	(
		select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space 
		from dba_free_space 
		group by tablespace_name
	) a, 
	(
		select tablespace_name, sum(bytes)/1024/1024 as tbs_size 
		from dba_data_files 
		group by tablespace_name
		UNION
		select tablespace_name, sum(bytes)/1024/1024 tbs_size
		from dba_temp_files
		group by tablespace_name
	) b
where a.tablespace_name(+)=b.tablespace_name
order by b.tablespace_name;
