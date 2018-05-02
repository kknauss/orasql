SELECT * FROM DBA_TAB_PARTITIONS;

SELECT * FROM DBA_PART_TABLES WHERE DEF_TABLESPACE_NAME IN ('DM_DATA','DW_DATA','DW_LD_DATA','DW_MT_DATA');

SELECT * FROM DBA_PART_INDEXES WHERE DEF_TABLESPACE_NAME IN ('DM_DATA','DW_DATA','DW_LD_DATA','DW_MT_DATA');


SELECT INITIAL_EXTENT FROM DBA_TABLES WHERE OWNER = 'DM_AFS' AND TABLE_NAME = 'AFS_ACCOUNT_NUM';


SELECT TABLESPACE_NAME, SUM(INITIAL_EXTENT) / (1024*1024*1024) SIZEGB FROM DBA_TAB_PARTITIONS WHERE TABLESPACE_NAME IN ('DM_DATA','DW_DATA','DW_LD_DATA','DW_MT_DATA') AND PARTITION_NAME LIKE '%201307%'
GROUP BY TABLESPACE_NAME
UNION
SELECT TABLESPACE_NAME, SUM(INITIAL_EXTENT) / (1024*1024*1024) SIZEGB FROM DBA_IND_PARTITIONS WHERE TABLESPACE_NAME IN ('DM_DATA','DW_DATA','DW_LD_DATA','DW_MT_DATA') AND PARTITION_NAME LIKE '%201307%'
GROUP BY TABLESPACE_NAME
ORDER BY TABLESPACE_NAME;