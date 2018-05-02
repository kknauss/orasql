SET verify OFF;
SET SPACE 0;
SET heading OFF;
SET feedback OFF;
SET pages 1000;
spool c:\keith\oracle\9iupgrade\planview\pvtrn_analyze.SQL
SELECT 'analyze '||object_type||' '||object_name||' validate structure;'
FROM dba_objects
WHERE owner = 'SYS'
AND object_type IN ('INDEX','TABLE','CLUSTER');
spool OFF