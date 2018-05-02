/*
	This view keeps information of every SQL statement and PL/SQL 
	block executed in the database. The following SQL can show you 
	statements with literal values or candidates to include bind 
	variables:
*/

column sql format a80;

SELECT substr(sql_text,1,80) "SQL",
count(*) ,
sum(executions) "TotExecs"
FROM v$sqlarea
WHERE executions < 5
GROUP BY substr(sql_text,1,80)
HAVING count(*) > 30
ORDER BY 2;
