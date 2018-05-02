--
--  Keith Knauss
--  12.29.2003
--  Tablespace Usage Report
--  Should calculate locally and/or dictionary managed temp tablespace usage too
--
set pagesize 66;
set linesize 125;

set verify off;
set feedback off;
set termout off;
column instance_name new_value iname;
column threshold     new_value thresh;
select instance_name, 90.00 threshold from v$instance;
set termout on;

ttitle 'Tablespace Report for &iname (Threshold: &thresh%)';
break on report;
compute sum   of "Alloc(KB)"    on report;
compute sum   of "Alloc(MB)"    on report;
compute sum   of "Alloc(GB)"    on report;
compute sum   of "Free(KB)"     on report;
compute sum   of "Free(MB)"     on report;
compute sum   of "Free(GB)"     on report;

column "Alloc(MB)" format 999990.99 ;
column "Alloc(GB)" format 999990.99 ;
column "Free(MB)"  format 999990.99 ;
column "Free(GB)"  format 999990.99 ;
column "Status"    format a6        ;
column "% used"    format a8        ;
column "%!"        format a2        ;
column "x!"        format a2        ;

select A.tablespace_name                                                               "Tablespace Name",
       case when A.status = 'ONLINE'    then 'rw'
            when A.status = 'READ ONLY' then 'r-'
            else '?' end                                                               "Status",
--            (sum_alloc_blks*(F.block_size/1024))                                       "Alloc(KB)",
       round( (sum_alloc_blks*(F.block_size/(1024*1024)))      ,2)                       "Alloc(MB)",
       round( (sum_alloc_blks*(F.block_size/(1024*1024*1024))) ,2)                       "Alloc(GB)",
--            (nvl(sum_free_blks,0)*(F.block_size/1024))                                 "Free(KB)",
       round( (nvl(sum_free_blks,0)*(F.block_size/(1024*1024)))       ,2)                "Free(MB)",
       round( (nvl(sum_free_blks,0)*(F.block_size/(1024*1024*1024)))  ,2)                "Free(GB)",
       to_char(100-(100*nvl(sum_free_blks,0)/sum_alloc_blks), '999.99') || '%'         "% used",
       nvl(D.mn,0)                                                                     "Max Next(KB)",
       nvl(E.mf,0)                                                                     "Max Free(KB)",
       case when (E.mf - D.mn) <= 0 then ' !' end                                      "x!",
       case when ((100-(100*nvl(sum_free_blks,0)/sum_alloc_blks)) >= &thresh) and (A.status != 'READ ONLY') then ' !' end "%!"
from 
--So we can get the status of each tablespaces defined in the instance.............................................
     dba_tablespaces A,
--So we can calculate allocated space for each tablespace..........................................................
     ( select tablespace_name, sum(blocks) as sum_alloc_blks 
         from dba_data_files 
     group by tablespace_name 
     union
       select y.name as tablespace_name, sum(x.blocks) as sum_alloc_blks 
         from v$tempfile x, v$tablespace y 
        where x.ts# = y.ts# 
     group by y.name)  B,
--So we can calculate freespace for any tablespaces that are not fully used........................................
     ( select tablespace_name,
              sum(blocks) as sum_free_blks
         from dba_free_space
     group by tablespace_name 
     union
       select a.name, (b.blocks-nvl(c.blocks_used,0)) sum_free_blks
         from v$tablespace a, (select ts#, sum(blocks) blocks from v$tempfile group by ts#) b, v$temp_extent_pool c
        where a.name = c.tablespace_name(+)
          and a.ts#  = b.ts# and a.name not in (select distinct tablespace_name from dba_free_space)) C,
--So we can calculate the largest next extent for objects by tablespace............................................
     (select max(next_extent/(1024)) mn, tablespace_name from dba_segments   group by tablespace_name) D,
     (select max(bytes      /(1024)) mf, tablespace_name from dba_free_space group by tablespace_name) E,
--So we can get db_block_size
     (select value block_size from v$parameter where name = 'db_block_size') F
  where A.tablespace_name = B.tablespace_name
    and A.tablespace_name = C.tablespace_name(+) 
    and A.tablespace_name = D.tablespace_name(+)
    and A.tablespace_name = E.tablespace_name(+)
;

ttitle off;
set verify on;
set feedback on;