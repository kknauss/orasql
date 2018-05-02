--
-- tsusg.sql Tablespace Usage
--
set linesize 132;
set verify off;

column tablespace_name heading 'Tablespace Name';
column tbsstatus       format a6 heading 'Status';
column pct_of_alloc format a10 heading '% used of|allocated';
column pct_of_max   format a10 heading '% used|of max';
column curr_alloc   heading 'Current|Allocation|MB';
column curr_free    heading 'Current|Free|MB';
column localmgd     format a10 heading 'Locally|Managed?';


select
	A.tablespace_name,
	case
		when A.status = 'ONLINE'	then 'rw'
		when A.status = 'READ ONLY'	then 'r-'
		else '?'
	end tbsstatus,
	case
		when A.extent_management = 'LOCAL'	then 'Y'
		else 'N'
	end localmgd,
	round(C.allocbytes/(1024*1024),2)						curr_alloc,
	round(C.allocbytes/(1024*1024),2) - round(D.bytes/(1024*1024),2)		curr_free,
	round(D.bytes/(1024*1024),2)							"Used(MB)",
	to_char(100-(100*nvl((C.allocbytes-D.bytes),0)/C.allocbytes), '9999.99') || '%'	pct_of_alloc,
	round(B.maxbytes/(1024*1024),2)							"Max Alloc(MB)", 
	to_char(100-(100*nvl((B.maxbytes-D.bytes),0)/B.maxbytes), '9999.99') || '%'	pct_of_max
from
    dba_tablespaces A,
--Get the maximum size of each tablespace..............................................................................
      ( select tablespace_name, sum(case when maxbytes = 0 then bytes else maxbytes end) maxbytes from dba_data_files  group by tablespace_name
      ) B,
--Calculate current allocated space for each tablespace................................................................
      (    select tablespace_name, sum(bytes) as allocbytes from dba_data_files group by tablespace_name
      ) C,
--Get the currnet usage of each tablespace (this is not that efficient)................................................
      (    select tablespace_name, sum(bytes) as bytes from dba_extents group by tablespace_name 
      ) D
where A.tablespace_name = B.tablespace_name
and   A.tablespace_name = C.tablespace_name
and   A.tablespace_name = D.tablespace_name
and   A.tablespace_name = upper(trim('&&tbspace'));
