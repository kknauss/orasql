SELECT --STATUS, 
'alter index '||OWNER||'.'||INDEX_NAME||' rebuild online;' rebuildstmt
--, '--'||table_owner||'.'||table_name tablenm
FROM DBA_INDEXES 
WHERE STATUS = 'UNUSABLE'
AND PARTITIONED = 'NO'
ORDER BY OWNER, INDEX_NAME;

SELECT --STATUS, 
'alter index '||INDEX_OWNER||'.'||INDEX_NAME||' rebuild partition '||PARTITION_NAME||' online;'
FROM DBA_IND_PARTITIONS
WHERE STATUS = 'UNUSABLE';

--lect * from dba_part_indexes;
