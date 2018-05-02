select * from dba_users where username like 'CDD%';

SELECT *
FROM DBA_ROLE_PRIVS 
where GRANTEE = 'ANALYST'
order by granted_role;

SELECT *
FROM DBA_ROLE_PRIVS where granted_role = 'DEVELOPMENT_USER';

SELECT LPAD(' ',DEPTH*3)||GRANTED_ROLE AS GRANTED_ROLE, DEFAULT_ROLE, ADMIN_OPTION
FROM (
          SELECT GRANTED_ROLE, DEFAULT_ROLE, ADMIN_OPTION, LEVEL AS DEPTH
          FROM DBA_ROLE_PRIVS 
          START WITH GRANTEE = 'SALAJANGI_DEV'
          CONNECT BY PRIOR GRANTED_ROLE = GRANTEE
          ORDER SIBLINGS BY GRANTED_ROLE
);

--SELECT ANY DICTIONARY
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'DEVELOPMENT_USER'; 

SELECT * FROM DBA_USERS WHERE USERNAME LIKE '%\_DEV' ESCAPE '\';

SELECT *
FROM DBA_ROLE_PRIVS 
where GRANTEE = 'DM_OBIEE_APPID' order by granted_role;

SELECT * from dba_Roles where role like 'DW%';

SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'BRAVURA_SELECT';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'SECMKTG_SELECT';

--LOAD_LPS.LOAN

select * FROM DBA_TAB_PRIVS where grantee = 'CDD_CLIENT' and table_name like 'UTL%';

--==============================================================================
SELECT * FROM DBA_TAB_PRIVS
WHERE 
  (OWNER = 'DM_CAP' and TABLE_NAME in ('OFHEO_MSA'));
  
DESC DM_CAP.OFHEO_MSA
DESC DM_CAP.OFHEO_STATE
  
SELECT * FROM DBA_TAB_PRIVS
WHERE 
  (OWNER = 'ERCM' and TABLE_NAME in ('IMPL_SAR_ACT_PTY'))
AND  
  (
      GRANTEE = 'CDD_CLIENT'
      OR
      GRANTEE IN (  SELECT GRANTED_ROLE
                    FROM DBA_ROLE_PRIVS 
                    START WITH GRANTEE = 'CDD_CLIENT'
                    CONNECT BY PRIOR GRANTED_ROLE = GRANTEE
                )
      );
      
--==============================================================================
SELECT * FROM DBA_TAB_PRIVS
WHERE 
  (OWNER = 'REPORT' and TABLE_NAME in ('SF_GET_MTG_STATUS_DATE','SF_CODE'))
/*  
 (
        (OWNER = ''  AND TABLE_NAME IN ('POM_MSP_MAPPING','POM_MSP_LOCATION'))
      OR
        (OWNER = 'DM' and TABLE_NAME in ('WEB_USER','WEB_ROLE'))
        OR
   
        (OWNER = 'LOAD_LPS'      AND TABLE_NAME = 'LOAN')
      )  */
AND  
  (
      GRANTEE = 'DM_OBIEE_APPID'
      OR
      GRANTEE IN (  SELECT GRANTED_ROLE
                    FROM DBA_ROLE_PRIVS 
                    START WITH GRANTEE = 'DM_OBIEE_APPID'
                    CONNECT BY PRIOR GRANTED_ROLE = GRANTEE
                )
      );
      
SELECT *
FROM DBA_TAB_PRIVS 
WHERE (
      GRANTEE = 'DM_OBIEE_APPID'
      OR
      GRANTEE IN (  SELECT GRANTED_ROLE
                    FROM DBA_ROLE_PRIVS 
                    START WITH GRANTEE = 'DM_OBIEE_APPID'
                    CONNECT BY PRIOR GRANTED_ROLE = GRANTEE
                )
      );
      
select * from dba_tab_privs where OWNER = 'DM_FINANCE' and TABLE_NAME = 'FS98_LOAD';