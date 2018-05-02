col owner format a15;
col table_name format a32;
col column_name format a32;

UNDEF ownr
UNDEF tabl

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept ownr prompt 'Table owner...... '
	accept tabl prompt 'Table name....... '
SET TERMOUT off;
	COLUMN ownr NEW_VALUE _ownr ;
	COLUMN tabl NEW_VALUE _tabl ;
	select case when '&&ownr' IS NULL then 'ALL' else     upper('&&ownr') end as ownr from dual;
	select case when '&&tabl' IS NULL then 'ALL' else     upper('&&tabl') end as tabl from dual;
SET TERMOUT on;


SELECT
	OWNER,
	TABLE_NAME,
	COLUMN_NAME,
	NUM_DISTINCT,
--	LOW_VALUE,
--	HIGH_VALUE,
--	DENSITY,
	NUM_NULLS,
	NUM_BUCKETS,
	to_char(LAST_ANALYZED, 'mm/dd/yyyy hh24:mi') LAST_ANALYZED,
	SAMPLE_SIZE,
--	GLOBAL_STATS,
--	USER_STATS,
	AVG_COL_LEN,
	HISTOGRAM
FROM dba_tab_col_statistics
WHERE ( owner      like '%&&_ownr%'  OR  'ALL' = '&&_ownr' )
AND   ( table_name like '%&&_tabl%'  OR  'ALL' = '&&_tabl' )
ORDER BY owner, table_name, column_name;

UNDEF ownr
UNDEF tabl
