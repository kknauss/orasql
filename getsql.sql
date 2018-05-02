SET VERIFY off;
UNDEF sqlid
col sql_Text format a128 heading 'SQL Text for SQL ID &&sqlid';
BREAK ON sql_id ;

SELECT SQL_TEXT
FROM V$SQLTEXT
WHERE SQL_ID = '&&sqlid'
ORDER BY PIECE;

UNDEF sqlid
