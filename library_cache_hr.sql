/*
	If the ratio of misses to executions is more than 1%, 
	then try to reduce the library cache misses by 
	increasing the shared pool size. 
*/

SELECT SUM(PINS) "EXECUTIONS", SUM(RELOADS) "CACHE MISSES WHILE EXECUTING", round ( ((SUM(RELOADS)/SUM(PINS)) * 100), 2) as percent
FROM V$LIBRARYCACHE;
