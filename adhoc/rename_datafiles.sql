set linesize 132;
set pagesize 0;
set feedback off;
set verify off;

spool tmp_rnme_df.sql;


SELECT 'alter database rename file '''||name||''' to '''||replace(name,'&&prod_filesystem','&&stg_filesystem')||''';'
FROM    v$datafile
UNION
SELECT 'alter database rename file '''||member||''' to '''||replace(member,'&&prod_filesystem','&&stg_filesystem')||''';'
FROM    v$logfile
UNION
SELECT 'alter database rename file '''||name||''' to '''||replace(name,'&&prod_filesystem','&&stg_filesystem')||''';'
FROM    v$tempfile
;


select '--recover database;'                                           from dual;
select '--alter database open;'                                        from dual;
select '--shutdown immediate;'                                         from dual;
select '--startup mount;'                                              from dual;
select '--nid TARGET="/ as sysdba" dbname=&&stg_filesystem'            from dual;
select '--startup mount;'                                              from dual;
select '--alter system set db_name=''&&stg_filesystem'' scope=spfile;' from dual;
select '--shutdown immediate;'                                         from dual;
select '--startup mount;'                                              from dual;
select '--alter database open resetlogs;'                              from dual;


spool off;
set pagesize 80;
set feedback on;

select user, host_name, instance_name from v$instance;

pause Press ENTER to rename datafiles ...

spool tmp_rnme_df.log;

@tmp_rnme_df.sql

spool off;
