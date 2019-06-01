SELECT --STATUS, 
'alter index '||OWNER||'.'||INDEX_NAME||' rebuild online;' rebuildstmt
--, '--'||table_owner||'.'||table_name tablenm
FROM DBA_INDEXES 
WHERE STATUS = 'UNUSABLE'
and owner = '&ownr'
AND PARTITIONED = 'NO'
ORDER BY OWNER, INDEX_NAME;

SELECT --STATUS, 
'alter index '||INDEX_OWNER||'.'||INDEX_NAME||' rebuild partition '||PARTITION_NAME||' online;'
FROM DBA_IND_PARTITIONS
WHERE STATUS = 'UNUSABLE'
and INDEX_OWNER= '&ownr' ;
