UNDEF usernm

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept usernm prompt 'User Name........ '
SET TERMOUT off;
	COLUMN usernm NEW_VALUE _usernm ;
	select case when '&&usernm' IS NULL then 'ALL' else     upper('&&usernm') end as usernm from dual;
SET TERMOUT on;

select u.username, u.password, u.account_status, u.default_tablespace, u.temporary_tablespace, u.profile, u.INITIAL_RSRC_CONSUMER_GROUP
from dba_users u
where ( u.username like '%&&_usernm%'  OR  'ALL' = '&&_usernm' );


/*
select u.username, s.password, u.account_status, u.default_tablespace, u.temporary_tablespace, u.profile, u.INITIAL_RSRC_CONSUMER_GROUP
from dba_users u, sys.user$ s
where ( u.username like '%&&_usernm%'  OR  'ALL' = '&&_usernm' )
and u.username = s.name;
*/


pause Press ENTER to see explicitly granted roles ...

SELECT *
FROM DBA_ROLE_PRIVS
WHERE ( grantee like '%&&_usernm%'  OR  'ALL' = '&&_usernm' );


pause Press ENTER to see implicitly granted roles ...

SELECT GRANTED_ROLE, LEVEL
FROM DBA_ROLE_PRIVS
START WITH ( grantee like '%&&_usernm%'  OR  'ALL' = '&&_usernm' )
CONNECT BY PRIOR GRANTED_ROLE = GRANTEE;
