accept ldapnm prompt '--LDAP username................................... '
accept crtype prompt '--Create account type (include the underscore).... '
accept crlike prompt '--Create like ID.................................. '


set heading off;
set feedback off;

WITH DUDE AS ( SELECT NME, LENGTH(NME) FROM ( SELECT UPPER('&&ldapnm')||UPPER('&&crtype') NME FROM DUAL ))
SELECT 'CREATE USER '||NME||' IDENTIFIED BY kk'||TO_CHAR(SYSDATE,'mmdd')||LOWER(SUBSTR(NME,1,2))
FROM DUDE
UNION
SELECT 'DEFAULT TABLESPACE '||DEFAULT_TABLESPACE||' TEMPORARY TABLESPACE '||TEMPORARY_TABLESPACE||' PROFILE '||PROFILE||';'
FROM DBA_USERS
WHERE USERNAME = UPPER('&&crlike');


WITH DUDE AS ( SELECT NME, LENGTH(NME) FROM ( SELECT UPPER('&&ldapnm')||UPPER('&&crtype') NME FROM DUAL ))
SELECT 'GRANT '||GRANTED_ROLE||' TO '||NME||';'
FROM DBA_ROLE_PRIVS, DUDE
WHERE GRANTEE = UPPER('&&crlike');

WITH DUDE AS ( SELECT NME, LENGTH(NME) FROM ( SELECT UPPER('&&ldapnm')||UPPER('&&crtype') NME FROM DUAL ))
SELECT 'ALTER USER '||NME||' QUOTA '||CASE MAX_BYTES WHEN -1 THEN 'UNLIMITED' ELSE TO_CHAR(MAX_BYTES/1024)||'K' END||' ON '||TABLESPACE_NAME||';' 
FROM DBA_TS_QUOTAS, DUDE
WHERE USERNAME = UPPER('&&crlike');

WITH DUDE AS ( SELECT NME, LENGTH(NME) FROM ( SELECT UPPER('&&ldapnm')||UPPER('&&crtype') NME FROM DUAL ))
SELECT 'GRANT '||PRIVILEGE||' to '||NME||CASE ADMIN_OPTION WHEN 'YES' THEN 'WITH ADMIN OPTION;' ELSE ';' END
FROM DBA_SYS_PRIVS, DUDE
WHERE GRANTEE = UPPER('&&crlike');

WITH DUDE AS ( SELECT NME, LENGTH(NME) FROM ( SELECT UPPER('&&ldapnm')||UPPER('&&crtype') NME FROM DUAL ))
SELECT 'GRANT '||PRIVILEGE||' on '||OWNER||'.'||TABLE_NAME||' TO '||NME|| CASE GRANTABLE WHEN 'YES' THEN ' WITH GRANT OPTION;' ELSE ';' END
FROM DBA_TAB_PRIVS, DUDE
WHERE GRANTEE = UPPER('&&crlike');


SELECT LINE
FROM (
	WITH DUDE AS ( SELECT NME, LENGTH(NME) FROM ( SELECT UPPER('&&ldapnm')||UPPER('&&crtype') NME FROM DUAL ))
        SELECT 1 AS ORD, 'BEGIN' LINE FROM DUAL
        UNION
        SELECT 2, q'[DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SWITCH_CONSUMER_GROUP (  ']'||NME||q'[', ']'||INITIAL_RSRC_CONSUMER_GROUP||q'[', TRUE );]' FROM DBA_USERS,DUDE WHERE USERNAME = UPPER('&&crlike')
        UNION
        SELECT 3, 'DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA();' FROM DUAL
        UNION
        SELECT 4, q'[DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING ( DBMS_RESOURCE_MANAGER.ORACLE_USER, ']'||NME||q'[', ']'||INITIAL_RSRC_CONSUMER_GROUP||q'[' );]' FROM DBA_USERS,DUDE WHERE USERNAME = UPPER('&&crlike')
        UNION
        SELECT 5, 'DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA();' FROM DUAL
        UNION
        SELECT 6, 'END;' FROM DUAL
        UNION
        SELECT 7, '/' FROM DUAL
)
ORDER BY ORD;

set heading on;
set feedback on;
