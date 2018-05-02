#set linesize 120;
#set pagesize 400;

#column owner format a12;
#column segment_type format a16;
#column segment_name format a32;
#column partition_name format a16;
#column tablespace_name format a18;

-- and block_id <= &blocknbr
-- and block_id+blocks >= &blocknbr

select owner, segment_type, segment_name, partition_name, tablespace_name, block_id as startblk, block_id+blocks-1 as endblk
  from dba_extents
 where file_id = &fileid
   and &blocknbr between block_id and block_id+blocks-1
;
