select * from v$datafile where name like '/u05%' order by file#;


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
select owner, segment_type, segment_name, partition_name, tablespace_name, block_id as startblk, block_id+blocks-1 as endblk, blocks, bytes/(1024*1024) sizeMB, round(((block_id-1)*8)/1024,2) block_start_MB_mark
  from dba_extents
 where file_id = &fileid
order by block_id desc ;

SELECT 'dd if=/dev/zero of=' || F.FILE_NAME || ' bs='||(SELECT VALUE FROM V$PARAMETER WHERE NAME = 'db_block_size')||' count=1 conv=notrunc seek=' || (S.HEADER_BLOCK + 1)
FROM DBA_SEGMENTS S, DBA_DATA_FILES F
WHERE S.SEGMENT_NAME = 'HEARTBEAT'
AND S.HEADER_FILE = F.FILE_ID;

select owner, segment_type, segment_name, partition_name, tablespace_name, block_id as startblk, block_id+blocks-1 as endblk, blocks, bytes/(1024*1024) sizeMB, round(((block_id-1)*8)/1024,2) block_start_MB_mark
  from dba_extents
 where segment_name = 'HEARTBEAT'
order by block_id ;

select owner, segment_type, segment_name, partition_name, tablespace_name, block_id as startblk, block_id+blocks-1 as endblk, blocks, bytes/(1024*1024) sizeMB, round(((block_id-1)*8)/1024,2) block_start_MB_mark
  from dba_extents
 where file_id = 4
order by block_id ;