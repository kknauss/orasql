select * from dba_objects where OWNER = '&&objown' AND object_NAME = '&&objnm';

select * from dba_users where username = '&usernm';

SELECT * FROM DBA_TAB_PRIVS 
WHERE (
        OWNER = '&objown'      AND TABLE_NAME = '&objnm'
      )
AND (
      GRANTEE = '&usernm'
      OR
      GRANTEE IN (  SELECT GRANTED_ROLE
                    FROM DBA_ROLE_PRIVS 
                    START WITH GRANTEE = '&usernm'
                    CONNECT BY PRIOR GRANTED_ROLE = GRANTEE
                )
      );
