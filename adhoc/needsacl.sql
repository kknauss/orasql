SELECT * FROM DBA_DEPENDENCIES
WHERE referenced_name IN ('UTL_TCP','UTL_SMTP','UTL_MAIL','UTL_HTTP','UTL_INADDR')
AND owner NOT IN ('SYS','PUBLIC','ORDPLUGINS')
ORDER BY OWNER, NAME, TYPE;

