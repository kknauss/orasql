SELECT * FROM DBA_OBJECTS WHERE OBJECT_NAME LIKE '%PROFILE%';

SELECT * FROM DBA_SQL_PROFILES;


SELECT DISTINCT SQL_ID 
FROM V$SQLTEXT WHERE SQL_ID IN (
 '31phmds2g00t5'
,'9fkyms8gm9rhj'
,'9nscsur644gt6'
,'6jzvj0qxhxfrw'
,'5cc401t9x7w24'
,'g9naqbkf1ktdq'
);

SELECT DISTINCT DBID, SQL_ID,  SQL_TEXT,  COMMAND_TYPE
FROM SYS.DBA_HIST_SQLTEXT WHERE SQL_ID IN (
 '31phmds2g00t5'
,'9fkyms8gm9rhj'
,'9nscsur644gt6'
,'6jzvj0qxhxfrw'
,'5cc401t9x7w24'
,'g9naqbkf1ktdq'
);


SELECT * FROM SYS.AUX_STATS$;



select SQL_ID,OUTLINE_CATEGORY, SQL_PROFILE --,SQL_TEXT
  from GV$SQL where SQL_ID in (
  '6jzvj0qxhxfrw',
  '9nscsur644gt6',
'31phmds2g00t5'
,'9fkyms8gm9rhj'
,'9nscsur644gt6'
,'6jzvj0qxhxfrw'
,'5cc401t9x7w24'
,'g9naqbkf1ktdq'
  );