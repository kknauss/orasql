select INDEX_TYPE, OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME
from DBA_INDEXES
where INDEX_TYPE like 'FUNCTION-BASED%';


select *
from DBA_IND_COLUMNS C
where exists
                (
                        select 1
                        from DBA_INDEXES I
                        where I.INDEX_OWNER = C.INDEX_OWNER
                        and   I.INDEX_NAME  = C.INDEX_NAME
                        and   I.TABLE_OWNER not in ('SYS','SYSTEM')
                        and   I.INDEX_TYPE like 'FUNCTION-BASED%'
                )
and 
order by INDEX_OWNER, INDEX_NAME, COLUMN_POSITION;



 select *
from DBA_INDEXES I
where I.TABLE_OWNER not in ('SYS','SYSTEM')
and   I.INDEX_TYPE like 'FUNCTION-BASED%'
and exists (
              select 1
              from DBA_IND_COLUMNS
              where )
              ;
              
              
          
              
select distinct data_type from dba_tab_columns where owner not in ('SYS','SYSTEM');

WITH IDXSWITHDATECOLS AS
(
  SELECT IC.INDEX_OWNER, IC.INDEX_NAME, IC.TABLE_OWNER, IC.TABLE_NAME, IC.COLUMN_NAME, TC.DATA_TYPE
  FROM DBA_IND_COLUMNS IC, DBA_TAB_COLUMNS TC
  WHERE IC.TABLE_OWNER = TC.OWNER
  AND IC.TABLE_NAME = TC.TABLE_NAME
  AND IC.COLUMN_NAME = TC.COLUMN_NAME
  AND IC.TABLE_OWNER NOT IN ('SYS','SYSTEM','OUTLN','DBSNMP')
  AND TC.DATA_TYPE = 'DATE'
)
SELECT I.INDEX_TYPE, I.TABLE_OWNER, I.TABLE_NAME, I.OWNER, I.INDEX_NAME
FROM DBA_INDEXES I
--ERE I.INDEX_TYPE LIKE 'FUNCTION-BASED%' AND 
WHERE EXISTS
          ( SELECT 1
            FROM IDXSWITHDATECOLS IC
            WHERE IC.INDEX_OWNER = I.OWNER
            AND IC.INDEX_NAME = I.INDEX_NAME
          )
ORDER BY I.TABLE_OWNER, I.TABLE_NAME, I.OWNER, I.INDEX_NAME;