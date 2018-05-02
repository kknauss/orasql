--Buffers by Object in Cache
set pagesize 120
set linesize 120
column object_name format a40

  select dbo.owner, dbo.object_name, dbo.object_type, count(bh.block#) as nbrblocks
    from v$bh bh, dba_objects dbo
   where bh.objd = dbo.object_id
     and dbo.owner != 'SYS'
group by dbo.owner, dbo.object_name, dbo.object_type
  having count(bh.block#) > 9
order by nbrblocks;
