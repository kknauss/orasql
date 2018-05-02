select 
sum(round( (sum_alloc_blks*(block_size/(1024*1024*1024))) ,2)  )Allocated_GB,
sum(round( (nvl(sum_free_blks,0)*(block_size/(1024*1024*1024)))  ,2)  )Free_GB,
sum(round( ((sum_alloc_blks-nvl(sum_free_blks,0))*(block_size/(1024*1024*1024)))  ,2)  )Used_GB
from ( select tablespace_name, sum(blocks) as sum_alloc_blks from dba_data_files group by tablespace_name ) ,
     ( select a.tablespace_name as fs_ts_name,
              max(blocks) as lg_free_chnk,
              count(blocks) as nr_free_chnk,
              sum(blocks) as sum_free_blks
         from dba_free_space a, dba_tablespaces b
        where a.tablespace_name = b.tablespace_name(+)
       group by a.tablespace_name ),
     (select value block_size from v$parameter where name = 'db_block_size')
where tablespace_name = fs_ts_name(+);