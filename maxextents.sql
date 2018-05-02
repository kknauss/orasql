SELECT * 
FROM (
                    SELECT A.OWNER, A.TABLE_NAME, A.MAX_EXTENTS, B.NBR_EXTENTS, (A.MAX_EXTENTS-B.NBR_EXTENTS) OVERHEAD
                    FROM
                      ( SELECT OWNER, TABLE_NAME, MAX_EXTENTS FROM DBA_TABLES) A,
                      ( SELECT OWNER,SEGMENT_NAME,COUNT(*) NBR_EXTENTS
                        FROM DBA_EXTENTS
                        WHERE SEGMENT_TYPE = 'TABLE'
                        GROUP BY OWNER, SEGMENT_NAME) B
                    WHERE A.OWNER = B.OWNER
                    AND A.OWNER NOT IN ('SYS','SYSTEM')
                    AND A.TABLE_NAME = B.SEGMENT_NAME
                    ORDER BY OVERHEAD
 ) WHERE ROWNUM < 11;

SELECT * 
FROM (
                    SELECT A.OWNER, A.INDEX_NAME, A.MAX_EXTENTS, B.NBR_EXTENTS, (A.MAX_EXTENTS-B.NBR_EXTENTS) OVRHEAD
                    FROM
                      ( SELECT OWNER, INDEX_NAME, MAX_EXTENTS FROM DBA_INDEXES) A,
                      ( SELECT OWNER,SEGMENT_NAME,COUNT(*) NBR_EXTENTS
                        FROM DBA_EXTENTS
                        WHERE SEGMENT_TYPE = 'INDEX'
                        GROUP BY OWNER, SEGMENT_NAME) B
                    WHERE A.OWNER = B.OWNER
                    AND A.OWNER NOT IN ('SYS','SYSTEM')
                    AND A.INDEX_NAME = B.SEGMENT_NAME
                    ORDER BY OVRHEAD
 ) WHERE ROWNUM < 11;
