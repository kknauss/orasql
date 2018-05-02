column tablespace_name  format   a12   heading 'Tablespace';
column blocks_total                    heading 'Blocks|Total';
column blocks_used                     heading 'Blocks|Used';
column MB_total                        heading 'MB|Total';
column MB_used                         heading 'MB|Used';
column nbr_dfs                         heading 'Number|Datafiles';
column nbr_tfs                         heading 'Number|Tempfiles';
column pct_used format 990.99          heading '% Used';

select
	b.tablespace_name tablespace_name,
	f.blocks_total blocks_total,
	nvl(t.blocks_used,0) blocks_used,
	(nvl(t.blocks_used,0) / f.blocks_total) * 100  pct_used,
	(f.blocks_total * b.block_size) / 1024 / 1024 MB_total,
	(nvl(t.blocks_used,0) * block_size) / 1024 / 1024 MB_used,
	nbr_dfs,
	nbr_tfs
from
	dba_tablespaces b,
	(
		select tablespace_name, sum(blocks) blocks_total, count(*) nbr_dfs, 0 nbr_tfs from dba_data_files group by tablespace_name
		union
		select tablespace_name, sum(blocks) blocks_total, 0 nbr_dfs, count(*) nbr_tfs from dba_temp_files group by tablespace_name
	) f,
	(
		select tablespace, sum(blocks) blocks_used from gv$tempseg_usage group by tablespace
	) t
where b.tablespace_name = f.tablespace_name
and   b.contents = 'TEMPORARY'
and   b.tablespace_name = t.tablespace(+);
