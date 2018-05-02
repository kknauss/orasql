set pagesize 66;
set linesize 89;

column instance_name new_value iname;
select instance_name from v$instance;

ttitle 'Tablespace Report (&iname)';
break on report;
--compute count of tablespace_name on report;
compute sum   of Allocated_KB    on report;
compute sum   of Free_KB         on report;


select tablespace_name,
     lg_free_chnk,
     nr_free_chnk,
     (sum_alloc_blks*8) Allocated_KB,
     (sum_free_blks*8) Free_KB,
     to_char(100*sum_free_blks/sum_alloc_blks, '999.99') || '%' as pct_free
from ( select tablespace_name, sum(blocks) as sum_alloc_blks
         from dba_data_files
         group by tablespace_name ) OUTER,
     ( select tablespace_name as fs_ts_name,
              max(blocks) as lg_free_chnk,
              count(blocks) as nr_free_chnk,
              sum(blocks) as sum_free_blks
         from dba_free_space
         group by tablespace_name )
where tablespace_name = fs_ts_name
order by tablespace_name ;
--order by Free_KB desc ;
