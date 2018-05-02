set echo on;

/*
 * *****************************************************************
 *   PLEASE RUN AS SYS.... ONLY SYS HAS PRIVILEGES ON THESE TABLES
 * *****************************************************************
*/

/*
select nam.ksppinm NAME, val.KSPPSTVL VALUE
from x$ksppi nam, x$ksppsv val
where nam.indx = val.indx
and nam.ksppinm like '%&param%'
order by 1;
*/

COLUMN parameter           FORMAT a37
COLUMN description         FORMAT a30 WORD_WRAPPED
COLUMN "Session VALUE"     FORMAT a10
COLUMN "Instance VALUE"    FORMAT a10
 

SELECT
	a.ksppinm  "Parameter",
	a.ksppdesc "Description",
	b.ksppstvl "Session Value",
	c.ksppstvl "Instance Value"
FROM
	sys.x$ksppi a,
	sys.x$ksppcv b,
	sys.x$ksppsv c
WHERE
	a.indx = b.indx
AND 
	a.indx = c.indx
AND
	a.ksppinm LIKE '%&param%' escape '/'
;

set echo off;
