set linesize 132;
set verify off;
set linesize 150;
set verify off;

col Referenced_By format a132
col References    format a132

--accept own prompt 'Enter table owner [&owndef]: ' default &owndef
--accept tbl prompt 'Enter table name  [&tbldef]: ' default &tbldef

define own = &1;
define tbl = &2;


select 'Table '||a.owner||'.'||a.table_name||' ('||a.constraint_name||') references '||b.owner||'.'||b.table_name||' ('||b.constraint_name||')  ['||a.status||']' as "References"
from    dba_constraints a,
        dba_constraints b
where   a.r_constraint_name = b.constraint_name
and     a.r_owner = b.owner
and     a.constraint_type = 'R'
and     a.owner = upper('&own')
and     a.table_name = upper('&tbl')
order by a.table_name, a.constraint_name
;

select 'Table '||a.owner||'.'||a.table_name||' ('||a.constraint_name||') references '||b.owner||'.'||b.table_name||' ('||b.constraint_name||')  ['||a.status||']' as "Referenced By"
from    dba_constraints a,
        dba_constraints b
where   a.r_constraint_name = b.constraint_name
and     a.r_owner = b.owner
and     a.constraint_type = 'R'
and     b.owner = upper('&own')
and     b.table_name = upper('&tbl')
order by a.table_name, a.constraint_name
;

set verify on;
