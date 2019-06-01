ttitle left	' ' SKIP 1 - 
'ASM DISKGROUP SPACE USAGE';

column name           format      a22;
column name           heading 'Diskgroup Name';

column total_gb       format 999999.99;
column free_gb        format 999999.99;
column total_gb       heading 'Total|GB';
column free_gb        heading 'Free|GB';

select
	NAME,
	round(TOTAL_MB/(1024), 2) as total_gb,
	round(FREE_MB /(1024), 2) as free_gb,
	(total_mb-free_mb) / total_mb as used_pct
from v$asm_diskgroup;




ttitle left	' ' SKIP 1 - 
'FRA SPACE USAGE';

column name           format       a22;
column quota_mb       format 999999.99;
column used_mb        format 999999.99;
column free_mb        format 999999.99;
column reclaimable_mb format 999999.99;

column name           heading 'Diskgroup Name';
column quota_mb       heading 'Quota|MB';
column used_mb        heading 'Used|MB';
column reclaimable_mb heading 'Reclaimable|MB';

select
        name,
        round(space_limit      /(1024*1024), 2) as quota_mb,
        round(space_used       /(1024*1024), 2) as used_mb,
        round((space_limit-space_used)       /(1024*1024), 2) as free_mb,
        round(space_reclaimable/(1024*1024), 2) as reclaimable_mb,
        number_of_files,
	round(space_used/space_limit*100,2) 			as pct_used,
        round(space_reclaimable/space_limit*100,2)		as pct_reclaimable,
	round((space_used-space_reclaimable)/space_limit*100,2)	as pct_used_effective
from v$recovery_file_dest;




ttitle left	' ' SKIP 1 - 
'FRA USAGE';

column FILE_TYPE                    format      a32;
column FILE_TYPE                    heading 'File Type';
column PERCENT_SPACE_USED           format 990.00 heading '%|Used';
column PERCENT_SPACE_RECLAIMABLE    heading '%|Reclaimable';
column NUMBER_OF_FILES              heading '#|Files';
column MB_USED                      heading 'Used|MB';
column MB_RECLAIMABLE               heading 'Reclaimable|MB';

SELECT	RAU.FILE_TYPE,
	RAU.PERCENT_SPACE_USED,
	(RAU.PERCENT_SPACE_USED/100 * RFD.SPACE_LIMIT) /1024/1024 MB_USED,
	RAU.PERCENT_SPACE_RECLAIMABLE,
	(RAU.PERCENT_SPACE_RECLAIMABLE/100 * RFD.SPACE_LIMIT) /1024/1024 MB_RECLAIMABLE,
	RAU.NUMBER_OF_FILES
FROM V$RECOVERY_AREA_USAGE RAU, V$RECOVERY_FILE_DEST RFD;

ttitle off;
