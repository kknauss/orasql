column privilege format a64;

SELECT LPAD(' ',(DEPTH-1)*5)||PRIVILEGE AS PRIVILEGE, PRIVTYPE , ADMIN_OPTION, IS_DEFAULT, IS_GRANTABLE
FROM (
            WITH X AS
            (
                SELECT GRANTEE, 'ROLE' PRIVTYPE, GRANTED_ROLE                                AS PRIVILEGE,        ADMIN_OPTION, DEFAULT_ROLE AS IS_DEFAULT, '-'       AS IS_GRANTABLE FROM DBA_ROLE_PRIVS
                UNION
                SELECT GRANTEE, 'SYS'  PRIVTYPE,                                                PRIVILEGE,        ADMIN_OPTION, '-'          AS IS_DEFAULT, '-'       AS IS_GRANTABLE FROM DBA_SYS_PRIVS
--                UNION
--                SELECT GRANTEE, 'TAB'  PRIVTYPE, OWNER||'.'||TABLE_NAME||' ['||PRIVILEGE||']' AS PRIVILEGE, '-' AS ADMIN_OPTION, '-'          AS IS_DEFAULT, GRANTABLE AS IS_GRANTABLE FROM DBA_TAB_PRIVS
            )
            SELECT PRIVTYPE, PRIVILEGE, ADMIN_OPTION, IS_DEFAULT, IS_GRANTABLE, LEVEL AS DEPTH
            FROM X
            START WITH GRANTEE = upper('&usernm')
            CONNECT BY PRIOR PRIVILEGE = GRANTEE
            ORDER SIBLINGS BY PRIVILEGE
      );
