column name format a24;
column value format a32;
column display_value format a32;

select * from v$nls_parameters;


select * from v$nls_parameters where parameter in ( 'NLS_CHARACTERSET' ,'NLS_NCHAR_CHARACTERSET');

select name, value, display_value from v$parameter where name in ( 'db_block_size', 'memory_target');
