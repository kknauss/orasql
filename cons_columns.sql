set verify off;

undefine own
undefine tbl

define owndef = 'PHASE2'
define tbldef = 'PERSON'

accept own prompt 'Enter table owner [&owndef]: ' default &owndef
accept tbl prompt 'Enter table name  [&tbldef]: ' default &tbldef

select owner, constraint_name, constraint_type 
from dba_constraints
where owner = upper('&&own')
and table_name = upper('&&tbl');

select column_name
from dba_cons_columns
where OWNER = upper('&&own')
and TABLE_NAME = upper('&&tbl')
and CONSTRAINT_NAME = upper('&constraint_name')
order by position;
