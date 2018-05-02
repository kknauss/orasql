set linesize 132;
set verify off;

undefine own
undefine tbl
undefine idx_own
undefine idx

define owndef = 'PHASE2'
define tbldef = 'PERSON'

accept own prompt 'Enter table owner [&owndef]: ' default &owndef
accept tbl prompt 'Enter table name  [&tbldef]: ' default &tbldef

select owner as index_owner, index_name, index_type 
from dba_indexes
where table_owner = upper('&&own')
and table_name = upper('&&tbl');

accept idx_own prompt 'Enter table owner [&owndef]: ' default &owndef

select column_name || ' ' || descend
from dba_ind_columns
where INDEX_OWNER = upper('&&idx_own')
and   INDEX_NAME  = upper('&&idx')
order by column_position;
