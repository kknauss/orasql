--
-- tsii.sql
-- Table Size Including Indexes
--
set verify off;
column indexname  format a30;
column tablename  format a30;
column column_name format a16;



SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept own prompt 'Table owner...... '
	accept tbl prompt 'Table name....... '
SET TERMOUT off;
	COLUMN own NEW_VALUE _own ;
	COLUMN tbl NEW_VALUE _tbl ;
	select case when '&&own' IS NULL then 'ALL'    else upper('&&own') end as own from dual;
	select case when '&&tbl' IS NULL then 'ALL'    else upper('&&tbl') end as tbl from dual;
SET TERMOUT on;




select OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, SUM(BYTES)/(1024*1024*1024) SIZEGB
from
(
	select OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS
	from DBA_EXTENTS E
	where exists (
			select 1
			from DBA_TABLES
			where (OWNER = '&&_own'  OR '&&_own' = 'ALL')
			and (TABLE_NAME = '&&_tbl'  OR  '&&_tbl' = 'ALL')
			and E.SEGMENT_NAME = TABLE_NAME
			and E.OWNER = OWNER
			and (E.SEGMENT_TYPE = 'TABLE' or E.SEGMENT_TYPE = 'TABLE PARTITION')
	)
	union all
	select OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS
	from DBA_EXTENTS E
	where exists (
			select 1
			from DBA_INDEXES
			where (TABLE_OWNER = '&&_own'  OR '&&_own' = 'ALL')
			and (TABLE_NAME = '&&_tbl'  OR  '&&_tbl' = 'ALL')
			and E.SEGMENT_NAME = INDEX_NAME
			and E.OWNER = OWNER
			and (E.SEGMENT_TYPE = 'INDEX' or E.SEGMENT_TYPE = 'INDEX PARTITION')
	)
	union all
	select OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS
	from DBA_EXTENTS E
	where exists (
			select 1
			from DBA_LOBS
			where (OWNER = '&&_own'  OR '&&_own' = 'ALL')
			and (TABLE_NAME = '&&_tbl'  OR  '&&_tbl' = 'ALL')
			and E.SEGMENT_NAME = SEGMENT_NAME
			and E.SEGMENT_TYPE = 'LOBSEGMENT'
	)
)
group by OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME
order by sum(bytes) desc;



undef own
undef tbl
set verify on;
