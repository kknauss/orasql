SELECT * FROM DBA_POLICIES WHERE OBJECT_NAME = 'VW_LOAN_BORROWER';

SELECT * FROM V$VPD_POLICY WHERE OBJECT_NAME = 'VW_LOAN_BORROWER';
SELECT * FROM DBA_POLICY_GROUPS;
SELECT * FROM DBA_POLICY_CONTEXTS;
SELECT * FROM DBA_SEC_RELEVANT_COLS;


/*
1wm0aavtx0f00
ftm83u0s5tgqf
2kf3ktgwk68gm
by7wt5fp5shph
9xwmqs85gbwu8
8zg05da67qfuc
2thsdjcwj73ng
46cpbk3fj3whc
dgtp5v6q3v3wt
66v9a4acb8z7j
1ga35ng5sdv1f
*/
SELECT PARSING_SCHEMA_NAME, ROWS_PROCESSED
FROM V$SQL 
WHERE SQL_ID = 'by7wt5fp5shph';

SELECT distinct SQL_ID FROM V$VPD_POLICY WHERE OBJECT_NAME = 'VW_LOAN_BORROWER';

SELECT GRANTED_ROLE, LEVEL
FROM DBA_ROLE_PRIVS
START WITH GRANTEE = 'DM_FS_SVC_APPID'
CONNECT BY PRIOR GRANTED_ROLE = GRANTEE;

SELECT GRANTED_ROLE, LEVEL
FROM DBA_ROLE_PRIVS
START WITH GRANTEE = 'KKROVVIDI_DEV'
CONNECT BY PRIOR GRANTED_ROLE = GRANTEE;

SELECT GRANTED_ROLE, LEVEL
FROM DBA_ROLE_PRIVS
START WITH GRANTEE = 'KNAUSS_DBA'
CONNECT BY PRIOR GRANTED_ROLE = GRANTEE;

SELECT * FROM DBA_USERS WHERE USERNAME LIKE 'K%';

SELECT * FROM DW_GATEWAY.VW_LOAN_BORROWER;

SELECT * FROM DBA_DEPENDENCIES WHERE REFERENCED_NAME = 'VW_LOAN_BORROWER' AND REFERENCED_OWNER = 'DW_GATEWAY';

SELECT * FROM DBA_DEPENDENCIES WHERE NAME = 'VW_LOAN_BORROWER' AND OWNER = 'DW_GATEWAY';

SELECT * FROM DBA_views WHERE VIEW_NAME = 'VW_LOAN_BORROWER' AND OWNER = 'DW_GATEWAY';

SELECT * 
FROM DBA_DEPENDENCIES 
WHERE NAME = 'VW_LOAN_BORROWER' 
AND OWNER = 'DW_GATEWAY';

--dw_common.data_source_dim
SELECT * 
FROM DBA_DEPENDENCIES 
WHERE NAME = 'VW_DATA_SOURCE_DIM' 
AND OWNER = 'DW_GATEWAY';

--dw_flatods.party
SELECT * 
FROM DBA_DEPENDENCIES 
WHERE NAME = 'VW_NEW_FCO_PARTY' 
AND OWNER = 'DW_GATEWAY';