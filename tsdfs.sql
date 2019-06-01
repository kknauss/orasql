--
-- tsdfs.sql Tablespace Data Files
--
set verify off;
--t pagesize 1024;
--t linesize  180;
column file_name format a50;
column tablespace_name format a22;
column bytes format 99999999999
column sizeGB format 990.99
column sizeMB format 999999990.99
column ut NOPRINT new_value uppertbspc;

select upper('&&tbspace') ut from dual;

break on report;
compute sum label Total of sizeMB on report;
ttitle 'Tablespace: &&uppertbspc' LEFT skip 2;

select
	round(bytes/(1024*1024*1024),2) as sizeGB,
	round(bytes/(1024*1024),2) as sizeMB,
--	bytes,
	FILE_ID,
	FILE_NAME,
--	TABLESPACE_NAME,
--	STATUS,
	MAXBYTES/(1024*1024) as maxMB,
	AUTOEXTENSIBLE
from
	dba_data_files df
where
	tablespace_name = upper('&&tbspace')
order by
	file_id;
--	file_name;


clear columns
clear breaks
ttitle off;
