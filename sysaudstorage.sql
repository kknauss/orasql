COLUMN TABLESPACE_NAME FORMAT a22
COLUMN OWNER           FORMAT a18
COLUMN SEGMENT_NAME    FORMAT a18
COLUMN SEGMENT_TYPE    FORMAT a18

SELECT TABLESPACE_NAME, OWNER, SEGMENT_NAME, SEGMENT_TYPE, INITIAL_EXTENT, NEXT_EXTENT, PCT_INCREASE, MAX_EXTENTS, EXTENTS, BYTES/(1024*1024) MB FROM DBA_SEGMENTS WHERE SEGMENT_NAME = 'AUD$';
