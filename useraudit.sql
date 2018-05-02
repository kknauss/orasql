alter session set nls_date_format = 'MM/DD/YYYY HH24:MI:SS';

SELECT username, account_status, created, nvl(is_dba,' ') is_dba, nvl(is_schema,' ') is_schema, nvl(is_readwrite,' ') is_readwrite
FROM dba_users u 
LEFT JOIN ( select distinct grantee, 'Yes' as is_dba  --Get all roles/users with DBA
            from dba_role_privs
            connect by prior grantee = granted_role
            start with granted_role = 'DBA') dba
ON (u.username = dba.grantee)
LEFT JOIN ( select distinct owner, 'Yes' as is_schema
            from dba_objects
            where object_type != 'SYNONYM') sch
ON (u.username = sch.owner)
LEFT JOIN (--Users and roles with --rw-- capabilities...
            select distinct grantee, 'Yes' as is_readwrite
            from dba_tab_privs 
            where privilege in ('ALTER','DELETE','INSERT','INDEX','REFERENCES','UNDER','UPDATE')
            UNION
            --Users and roles with --rw-- capabilities granted via a role (or series of)...
            select distinct grantee, 'Yes' as is_readwrite
            from dba_role_privs
            connect by prior grantee = granted_role
            start with granted_role in (select grantee
                                        from dba_tab_privs
                                        where privilege in ('ALTER','DELETE','INSERT','INDEX','REFERENCES','UNDER','UPDATE'))) rw
ON (u.username = rw.grantee)
WHERE u.username NOT IN ('CTXSYS','DBSNMP','DIP','EXFSYS','MGMT_VIEW','OUTLN','SYS','SYSMAN','SYSTEM','TSMSYS')
ORDER BY u.username;