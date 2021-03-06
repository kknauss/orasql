col used_mb      format 9999990.99
col free_mb      format 9999990.99
col allocated_mb format 9999990.99
col pct_free     format 990.99
col pct_used     format 990.99
col non_system_schemas format a132

break on report;
compute sum of used_mb      on report;
compute sum of free_mb      on report;
compute sum of allocated_mb on report;

WITH 
  ITSINTHERE AS
  (
    SELECT TABLESPACE_NAME, LISTAGG (OWNER, ',') WITHIN GROUP (ORDER BY OWNER) NON_SYSTEM_SCHEMAS
    FROM (
            SELECT DISTINCT TABLESPACE_NAME, OWNER
            FROM DBA_SEGMENTS
            WHERE OWNER NOT IN ('SYS','SYSTEM','APPQOSSYS','AQUSER','BACKUP','DBSNMP','EXFSYS','OUTLN','PERFSTAT','XDB')
        )
    GROUP BY TABLESPACE_NAME
  ),
  FREESPACE AS
  (
    SELECT TABLESPACE_NAME, SUM(BYTES) FREE_SPACE FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME
    UNION
    SELECT TABLESPACE_NAME, FREE_SPACE FROM DBA_TEMP_FREE_SPACE
  ),
  ALLOCATED AS
  (
    SELECT TABLESPACE_NAME, COUNT(FILE_ID) NBRFILES, SUM(BYTES) ALLOCATED, SUM(MAXBYTES) MAX_SPACE
    FROM DBA_DATA_FILES
    GROUP BY TABLESPACE_NAME
    UNION
    SELECT TABLESPACE_NAME, COUNT(FILE_ID) NBRFILES, SUM(BYTES) ALLOCATED, SUM(MAXBYTES) MAX_SPACE
    FROM DBA_TEMP_FILES
    GROUP BY TABLESPACE_NAME
  )
SELECT
  TABLESPACE_NAME,
  CONTENTS,
  NBRFILES,
  ROUND( ALLOCATED/1024/1024, 2) ALLOCATED_MB,
  ROUND( (ALLOCATED-FREE_SPACE)/1024/1024, 2) USED_MB,
  ROUND( FREE_SPACE/1024/1024, 2) FREE_MB,
  ROUND( FREE_SPACE/ALLOCATED*100, 2) PCT_FREE,
  ROUND( (ALLOCATED-FREE_SPACE)/ALLOCATED*100, 2) PCT_USED,
  NON_SYSTEM_SCHEMAS
FROM ALLOCATED JOIN DBA_TABLESPACES USING (TABLESPACE_NAME) LEFT OUTER JOIN FREESPACE USING (TABLESPACE_NAME) LEFT OUTER JOIN ITSINTHERE USING (TABLESPACE_NAME)
ORDER BY
  TABLESPACE_NAME
--USED_MB DESC
;
