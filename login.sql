SET TERMOUT OFF;
--FINE _EDITOR=UEDIT32;
DEFINE _EDITOR=NOTEPAD;
--FINE _EDITOR=C:\Users\kknauss\Keith\Utilities\npp.6.5.3\notepad++
--T TIME          ON;
SET SQLBLANKLINES ON;
SET SERVEROUTPUT  ON SIZE 1000000;
SET TRIMSPOOL     ON;
SET VERIFY        OFF;
SET LONG          5000;
SET LINESIZE      255;
SET PAGESIZE      9999;

COLUMN PLAN_PLUS_EXP FORMAT A80
COLUMN X NEW_VALUE Y;

SELECT LOWER(USER) || '@' || LOWER(SYS_CONTEXT('USERENV', 'INSTANCE_NAME')) || ' (' || LOWER(SYS_CONTEXT('USERENV', 'SERVER_HOST')) || ') SQL> ' AS X FROM DUAL;
SET SQLPROMPT "&&Y";
SET TERMOUT ON;
