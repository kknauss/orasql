SET VERIFY   OFF;
SET FEEDBACK OFF;

COLUMN FILE_SYSTEM     format a42 heading 'File system';
COLUMN FILE_NAME       format a42 heading 'File name (* = tempfile)';
COLUMN TABLESPACE_NAME format a22 heading 'Tablespace name';
COLUMN autoextensible  format  a4 heading 'Ext-|end?';

COLUMN ALLOCMB FORMAT 99999990.00 heading 'Allocated|(MB)';
COLUMN FREEMB  FORMAT 99999990.00 heading 'Free (MB)';
COLUMN USEDMB  FORMAT 99999990.00 heading 'Used (MB)';
COLUMN MAXMB   FORMAT 99999990.00 heading 'Max (MB)';
COLUMN PCTUSED FORMAT      990.00 heading '%|used';
COLUMN FILE_ID FORMAT     9999    heading 'File|ID';

COMPUTE SUM LABEL ' '     OF ALLOCMB ON FILE_SYSTEM;
COMPUTE SUM               OF FREEMB  ON FILE_SYSTEM;
COMPUTE SUM               OF USEDMB  ON FILE_SYSTEM;
COMPUTE SUM LABEL 'TOTAL' OF ALLOCMB ON REPORT;
COMPUTE SUM               OF FREEMB  ON REPORT;
COMPUTE SUM               OF USEDMB  ON REPORT;

BREAK ON FILE_SYSTEM SKIP 1 ON REPORT skip 1;

SET TERMOUT OFF;
COLUMN INSTANCE_NAME NEW_VALUE INAME;
COLUMN HOST_NAME     NEW_VALUE HNAME;
SELECT INSTANCE_NAME, HOST_NAME FROM V$INSTANCE;
SET TERMOUT ON;

TTITLE 'Database Report for &iname (&hname) by File System';


SELECT 
        SUBSTR(name,1,INSTR(name,'/',-1)) file_system, 
        SUBSTR(name,  INSTR(name,'/',-1)+1) file_name, 
        null autoextensible,
        '(control file)' tablespace_name, 
	(block_size*file_size_blks) / (1024*1024) allocMB,
	null freeMB,
	null usedMB,
	null pctused,
	null maxMB
from v$controlfile
UNION ALL
SELECT 
        SUBSTR(member,1,INSTR(member,'/',-1)) file_system, 
        SUBSTR(member,  INSTR(member,'/',-1)+1) file_name,
        null autoextensible,
        '(redo log)' tablespace_name, 
        bytes / (1024*1024) allocMB,
	null freeMB,
	null usedMB,
	null pctused,
	null maxMB
from v$logfile lf, v$log l
where lf.group# = l.group#
UNION ALL
SELECT  
        SUBSTR(df.file_name,1,INSTR(df.file_name,'/',-1)) file_system, 
        SUBSTR(df.file_name,  INSTR(df.file_name,'/',-1)+1) file_name,
        case autoextensible WHEN 'YES' THEN 'yes' ELSE ' ' END autoextensible,
        df.tablespace_name, 
        df.bytes / (1024*1024) allocMB,
        fs.freebytes / (1024*1024) freeMB,
        (df.bytes - fs.freebytes) / (1024*1024) usedMB,
        ROUND((((df.bytes - fs.freebytes) / df.bytes) * 100),2) pctused,
        CASE df.maxbytes WHEN 0 THEN df.bytes ELSE df.maxbytes END  / (1024*1024) maxMB
FROM
        dba_data_files df,
        (SELECT file_id, sum(bytes) freebytes FROM dba_free_space GROUP BY file_id) fs
WHERE
        df.file_id = fs.file_id(+)
UNION ALL
SELECT 
        SUBSTR(tf.file_name,1,INSTR(tf.file_name,'/',-1)) file_system, 
        SUBSTR(tf.file_name,  INSTR(tf.file_name,'/',-1)+1)||' *' file_name,
        case autoextensible WHEN 'YES' THEN 'yes' ELSE ' ' END autoextensible,
        tf.tablespace_name, 
        tf.bytes / (1024*1024) allocMB,
        (tf.bytes - t.bytes_cached) / (1024*1024) freeMB,
        t.bytes_cached / (1024*1024) usedMB,
        ROUND( ((t.bytes_cached/tf.bytes) * 100), 2) pctused,
        CASE tf.maxbytes WHEN 0 THEN tf.bytes ELSE tf.maxbytes END  / (1024*1024) maxMB
FROM
        dba_temp_files tf, 
        v$temp_extent_pool t, 
        v$tempfile v
WHERE
        t.file_id(+) = tf.file_id
AND
        tf.file_id = v.file#
ORDER BY file_SYSTEM, FILE_NAME;


TTITLE off;
SET VERIFY ON;
SET FEEDBACK ON;
