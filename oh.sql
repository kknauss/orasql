column oracle_base          format a40 heading 'ORACLE_BASE guess';
column relative_oracle_home format a40 heading 'Relative ORACLE_HOME guess';
column oracle_home          format a80 heading 'ORACLE_HOME guess';

select 
    substr(value, 1, instr(value, '/admin') -1) as oracle_base,
    substr(
        substr (file_spec, 1, instr(file_spec, '/lib/libqsmashr.')- 1)
        ,length(substr(value, 1, instr(value, '/admin') +1))
        )  as relative_oracle_home,
    substr (file_spec, 1, instr(file_spec, '/lib/libqsmashr.')- 1) as oracle_home
from dba_libraries l, v$parameter p
where l.owner = 'SYS' and l.library_name = 'DBMS_SUMADV_LIB'
and p.name = 'background_dump_dest';
