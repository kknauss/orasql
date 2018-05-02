set linesize 180;
set pagesize 1024;
SET VERIFY off;

UNDEF sqlid
UNDEF childnbr

--lect * from table(dbms_xplan.DISPLAY_CURSOR('&sqlid', &childnbr ));
select * from table(dbms_xplan.DISPLAY_CURSOR('&sqlid'));

UNDEF sqlid
UNDEF childnbr
