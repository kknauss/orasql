column index_owner format a32
column owner format a32

SELECT index_owner, count(*) nbr_inv_part
FROM DBA_IND_PARTITIONS
WHERE STATUS = 'UNUSABLE'
group BY index_owner;


select owner , count(*) nbr_inv_nonp
FROM DBA_INDEXES
WHERE STATUS = 'UNUSABLE'
AND PARTITIONED = 'NO'
group BY OWNER
ORDER BY OWNER;
