set echo off;
set feedback off;
set serveroutput on;

DECLARE


v_total_plsql_mem	NUMBER	:= 0;
v_total_sql_mem		NUMBER	:= 0;
v_total_sharable_mem	NUMBER	:= 0;

BEGIN

	SELECT sum(sharable_mem)
	INTO v_total_plsql_mem
	FROM v$db_object_cache;

	SELECT sum(sharable_mem)
	INTO v_total_sql_mem
	FROM v$sqlarea
	WHERE executions > 10;

	v_total_sharable_mem := v_total_plsql_mem + v_total_sql_mem;

	DBMS_OUTPUT.PUT_LINE ( 'Estimated required shared pool size is: ' || to_char(v_total_sharable_mem,'fm9,999,999,999,999')||' bytes');

END;
/
