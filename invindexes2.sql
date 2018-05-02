SELECT index_owner, count(*)
FROM DBA_IND_PARTITIONS
WHERE STATUS = 'UNUSABLE'
group BY index_owner;

