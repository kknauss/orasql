set linesize 120;
set pagesize 400;

column owner format a12;
column segment_type format a16;
column segment_name format a32;
column partition_name format a16;
column tablespace_name format a18;

-- and block_id <= &blocknbr
-- and block_id+blocks >= &blocknbr
--391673 391680 3133384
select owner, segment_type, segment_name, tablespace_name, round(sum(bytes)/(1024*1024*1024),2) sizeGB, count(*) nbr_extents
  FROM DBA_EXTENTS
 where tablespace_name = upper('&tbspace')
group by owner, segment_type, segment_name, tablespace_name 
order by sum(bytes) desc;


select sum(bytes)/(1024*1024*1024) sizeGB
  FROM DBA_EXTENTS
 where tablespace_name = upper('&tbspace');


select * from dba_extents where SEGMENT_NAME = 'SYS_LOB0000022074C00054$$' order by extent_id;

select bytes, count(*)
from dba_extents 
where SEGMENT_NAME = 'SYS_LOB0000022074C00054$$'
group by bytes
order by bytes;

select * from dba_lobs where segment_name = 'SYS_LOB0000022074C00054$$';