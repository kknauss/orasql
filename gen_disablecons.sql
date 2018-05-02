set linesize 150;

set heading off;
set feedback off;
set verify off;
set escape off;


col Referenced_By format a132
col References    format a132

def owndef = 'PHASE2';
def tbldef = 'PERSON';

accept own prompt 'Enter table owner [&owndef]: ' default &owndef
accept tbl prompt 'Enter table name  [&tbldef]: ' default &tbldef

column timecol         new_value timestamp
column output          new_value dbname

select to_char(sysdate,'yyyymmdd_hh24mi') timecol from sys.dual;
select value output                               from v$parameter where name = 'db_name';

spool disable_constraints.&&own..&&tbl..&&dbname..&&timestamp..sql;


select '--Table '||a.owner||'.'||a.table_name||' ('||a.constraint_name||') references '||b.owner||'.'||b.table_name||' ('||b.constraint_name||')' as Referenced_By
from	dba_constraints a,
	dba_constraints b
where	a.r_constraint_name = b.constraint_name
and	a.r_owner = b.owner
and	a.constraint_type = 'R'
and 	b.owner = upper('&own')
and 	b.table_name = upper('&tbl')
;

select 'alter table '||a.owner||'.'||a.table_name||' disable constraint '||a.constraint_name||';'
from	dba_constraints a,
	dba_constraints b
where	a.r_constraint_name = b.constraint_name
and	a.r_owner = b.owner
and	a.constraint_type = 'R'
and	a.status = 'ENABLED'
and 	b.owner = upper('&own')
and 	b.table_name = upper('&tbl')
;

set pagesize 0;
select '/*' from dual;
select ' * alter table '||a.owner||'.'||a.table_name||' enable constraint '||a.constraint_name||';'
from	dba_constraints a,
	dba_constraints b
where	a.r_constraint_name = b.constraint_name
and	a.r_owner = b.owner
and	a.constraint_type = 'R'
and	a.status = 'ENABLED'
and 	b.owner = upper('&own')
and 	b.table_name = upper('&tbl')
;
select ' */' from dual;

set pagesize 55;
spool off;
set heading on;
set verify on;
set feedback on;
set escape on;
