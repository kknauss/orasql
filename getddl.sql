set heading off;
set feedback off;
set long 2000000000;
set pagesize 0;
set linesize 255;



spool getddl.log;

select dbms_metadata.get_ddl(upper('&objtype'),upper('&objname'),upper('&objown')) from dual;

spool off;
