SET VERIFY off;

column id             format  9909    heading 'Id';
column operation      format  a90    heading 'Operation';
column object         format   a38    heading 'Object';
column optimizer      format   a12    heading 'Optimizer';
column sql_id_child   format   a18    heading 'SQL_ID,Child#'
column partition_start format   a18    heading 'Part|Start'
column partition_stop  format   a18    heading 'Part|Stop'
column partition_id    format   999    heading 'Part|ID'

BREAK ON sql_id_child SKIP 1;

UNDEF instid
UNDEF sqlid
UNDEF hashval
UNDEF plnhashval



SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ....
	prompt
	accept instid     prompt 'Instance ID....... '
	accept sqlid      prompt 'SQL ID............ '
	accept hashval    prompt 'Hash Value........ '
	accept plnhashval prompt 'Plan Hash Value... '
SET TERMOUT off;
	COLUMN instid     NEW_VALUE _instid ;
	COLUMN sqlid      NEW_VALUE _sqlid ;
	COLUMN hashval    NEW_VALUE _hashval ;
	COLUMN plnhashval NEW_VALUE _plnhashval ;

	select case when '&&instid'     IS NULL then 0     else to_number('&&instid')     end as instid     from dual;
	select case when '&&sqlid'      IS NULL then 'ALL' else     lower('&&sqlid')      end as sqlid      from dual;
	select case when '&&hashval'    IS NULL then 0     else to_number('&&hashval')    end as hashval    from dual;
	select case when '&&plnhashval' IS NULL then 0     else to_number('&&plnhashval') end as plnhashval from dual;
SET TERMOUT on;


SELECT
	SQL_ID || ',' || CHILD_NUMBER  sql_id_child,
	LPAD(' ', DEPTH*2) || OPERATION || ' '|| OPTIONS OPERATION,
	OBJECT_OWNER ||CASE WHEN OBJECT_OWNER IS NOT NULL THEN '.' END || OBJECT_NAME OBJECT,
	OPTIMIZER,
	SEARCH_COLUMNS COLS,
	COST,
	CARDINALITY,
	BYTES,
PLAN_HASH_VALUE,
PARTITION_START,
PARTITION_STOP,
PARTITION_ID
FROM GV$SQL_PLAN P
WHERE EXISTS (
		SELECT 1
		FROM GV$SQL S
		WHERE S.ADDRESS = P.ADDRESS
		AND  S.HASH_VALUE = P.HASH_VALUE
		AND  S.CHILD_NUMBER = P.CHILD_NUMBER
		AND S.INST_ID = P.INST_ID
		AND ( S.SQL_ID = '&&_sqlid'             OR  'ALL' = '&&_sqlid')
		AND ( S.INST_ID = &&_INSTID             OR     0  =  &&_INSTID )
		AND ( S.HASH_VALUE = &&_HASHVAL         OR     0  =  &&_HASHVAL )
		AND ( S.PLAN_HASH_VALUE = &&_PLNHASHVAL OR     0  =  &&_PLNHASHVAL )
	)
ORDER BY INST_ID, SQL_ID, CHILD_NUMBER, ID;

prompt select * from table(dbms_xplan.DISPLAY_CURSOR('<sqlid>', <childnbr> ));

UNDEF instid
UNDEF sqlid
UNDEF hashval
UNDEF plnhashval
