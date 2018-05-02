create table t1 as
select
trunc((rownum-1)/100) n1,
rpad('x',100) padding
from
all_objects
where
rownum <= 1000
;

set autotrace traceonly explain;

select 
	* 
from	t1
where
	n1 in (1,2)
;
--================================================================================
set autotrace traceonly explain;

select 
	* 
from	t1
where
	n1 in (101,102)
;
--================================================================================
DECLARE
  START_YEAR_IN NUMBER := 10;
  END_YEAR_IN   NUMBER := 20;
  l_current_year PLS_INTEGER := start_year_in;
BEGIN
   LOOP
      EXIT WHEN L_CURRENT_YEAR > END_YEAR_IN;
      dbms_output.put_line('Total sales '||l_current_year);
      l_current_year :=  l_current_year + 1;
   END LOOP;
END;
/

DECLARE
  START_YEAR_IN NUMBER := 10;
  END_YEAR_IN   NUMBER := 20;
  l_current_year PLS_INTEGER := start_year_in;
BEGIN
  WHILE (l_current_year <= end_year_in)
  LOOP
      dbms_output.put_line('Total sales '||l_current_year);
      L_CURRENT_YEAR :=  L_CURRENT_YEAR + 1;
  END LOOP;
END;
/

select * from v$instance;

SELECT INSTR('steven feuerstein', 's',  1, 1) FROM DUAL;
SELECT INSTR('steven feuerstein', 'e', -1, 2) FROM DUAL;
SELECT CONCAT('steven','feuerstein') FROM DUAL;
select initcap('this is a test of the emergency broadcast system') from dual;

SELECT TRANSLATE('K1e2i3th4 I5s 6C7o9ol',  '1234567890',  '') FROM DUAL;
SELECT TRANSLATE('K1e2i3th4 I5s 6C7o9ol', 'A1234567890', 'A') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'Day, DDth Month YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'Day, DDth Month YYYY','NLS_DATE_LANGUAGE=Spanish') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'FMDay, DDth Month YYYY') FROM DUAL;


SELECT 
  CUST_GENDER GENDER
  ,NVL(CUST_MARITAL_STATUS, 'unknown') MARITAL_STATUS
  ,COUNT(*)
FROM SH.CUSTOMERS
GROUP BY CUST_GENDER, NVL(CUST_MARITAL_STATUS, 'unknown')
ORDER BY NVL(CUST_MARITAL_STATUS, 'unknown'), CUST_GENDER;

SELECT 
  CUST_GENDER GENDER
  ,NVL(CUST_MARITAL_STATUS, 'unknown') MARITAL_STATUS
  ,COUNT(*)
FROM SH.CUSTOMERS
GROUP BY CUST_GENDER, ROLLUP(NVL(CUST_MARITAL_STATUS, 'unknown'))
ORDER BY CUST_GENDER, NVL(CUST_MARITAL_STATUS, 'unknown');


SELECT
    CUST_GENDER GENDER
  , NVL(CUST_MARITAL_STATUS, 'unknown') MARITAL_STATUS
  , COUNT(*)
FROM SH.CUSTOMERS
GROUP BY ROLLUP(CUST_GENDER, NVL(CUST_MARITAL_STATUS, 'unknown'))
ORDER BY CUST_GENDER, NVL(CUST_MARITAL_STATUS, 'unknown');


SELECT
    CUST_GENDER GENDER
  , NVL(CUST_MARITAL_STATUS, 'unknown') MARITAL_STATUS
  , COUNT(*)
FROM SH.CUSTOMERS
GROUP BY CUBE(CUST_GENDER, NVL(CUST_MARITAL_STATUS, 'unknown'))
ORDER BY CUST_GENDER, NVL(CUST_MARITAL_STATUS, 'unknown');


SELECT 
    SUM(DECODE(NAME, 'sorts (memory)', VALUE, 0)) IN_MEMORY
  , SUM(DECODE(NAME, 'sorts (disk)', VALUE, 0)) ON_DISK
  , SUM(DECODE(NAME, 'sorts (rows)', VALUE, 0)) ROWS_SORTED
from v$myssytat;




declare
l_salary number := 20000;
begin
case when l_salary between 10000 and 19999 then dbms_output.put_line('one');
     when l_salary between 20000 and 30000 then dbms_output.put_line('two');
     when l_salary between     0 and 10000 then dbms_output.put_line('three');
end case;
end;
/
