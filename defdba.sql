select '!', grantee || ' has DBA as default!' msg
from dba_role_privs
where granted_role = 'DBA'
and grantee not in ('SYS','SYSTEM','OGGUSER','STREAMS_ADMIN', 'BACKUP','GGUSER','DATASTAGE','QRM_APPID','QRM_LOAD','QRM_MASTER')
and default_role = 'YES'
order by grantee;

WITH dbaaccts AS
(
    select GRANTEE user_name
    from dba_role_privs
    where granted_role = 'DBA'
    and grantee not in ('SYS','SYSTEM','OGGUSER','STREAMS_ADMIN', 'BACKUP','GGUSER','DATASTAGE')
),
reqd_audoptions as
(
select 'ALTER SEQUENCE' as audit_option from dual     UNION
select 'ALTER SYSTEM'             from dual                       UNION
select 'ALTER TABLE'              from dual                       UNION
select 'CLUSTER'                  from dual                       UNION
select 'COMMENT TABLE'            from dual                       UNION
select 'CONTEXT'                  from dual                       UNION
select 'DATABASE LINK'            from dual                       UNION
select 'DELETE TABLE'             from dual                       UNION
select 'DIMENSION'                from dual                       UNION
select 'DIRECTORY'                from dual                       UNION
select 'EXECUTE PROCEDURE'        from dual                       UNION
select 'GRANT DIRECTORY'          from dual                       UNION
select 'GRANT PROCEDURE'          from dual                       UNION
select 'GRANT SEQUENCE'           from dual                       UNION
select 'GRANT TABLE'              from dual                       UNION
select 'GRANT TYPE'               from dual                       UNION
select 'INDEX'                    from dual                       UNION
select 'INSERT TABLE'             from dual                       UNION
select 'LOCK TABLE'               from dual                       UNION
select 'MATERIALIZED VIEW'        from dual                       UNION
select 'MINING MODEL'             from dual                       UNION
select 'NOT EXISTS'               from dual                       UNION
select 'PROCEDURE'                from dual                       UNION
select 'PROFILE'                  from dual                       UNION
select 'PUBLIC DATABASE LINK'     from dual                       UNION
select 'PUBLIC SYNONYM'           from dual                       UNION
select 'ROLE'                     from dual                       UNION
select 'ROLLBACK SEGMENT'         from dual                       UNION
select 'SEQUENCE'                 from dual                       UNION
--lect 'SQL TRANSLATION PROFILE'  from dual                       UNION  this is only in 12c... don't think we need to check it
select 'SYNONYM'                  from dual                       UNION
select 'SYSTEM AUDIT'             from dual                       UNION
select 'SYSTEM GRANT'             from dual                       UNION
select 'TABLE'                    from dual                       UNION
select 'TABLESPACE'               from dual                       UNION
select 'TRIGGER'                  from dual                       UNION
select 'TYPE'                     from dual                       UNION
select 'UPDATE TABLE'             from dual                       UNION
select 'USER'                     from dual                       UNION
select 'VIEW'                     from dual
),
reqd_acct_options AS
(
  select * From dbaaccts cross join reqd_audoptions
),
matrix as (
    SELECT R.USER_NAME, R.AUDIT_OPTION, NVL(SAO.SUCCESS,'!') SUCCESS, NVL(SAO.FAILURE,'!') FAILURE
    FROM REQD_ACCT_OPTIONS R LEFT OUTER JOIN DBA_STMT_AUDIT_OPTS SAO ON (R.USER_NAME = SAO.USER_NAME AND R.AUDIT_OPTION = SAO.AUDIT_OPTION)
    AND SAO.SUCCESS = 'BY ACCESS'
    AND SAO.FAILURE = 'BY ACCESS'
)
select * from matrix where success = '!' or failure = '!'
order by user_name, audit_option;
