explain plan 
SET STATEMENT_ID = 'ktk'
for
SELECT AL1.ACCOUNT_NUM, AL1.ACCOUNT_STATUS_CODE, AL1.PAID_TO_DATE, AL1.UNPAID_PRINCIPAL_BALANCE_AMT, AL1.CONTROL_CODE, AL1.ACCOUNT_TYPE_CODE, AL1.UPB_GENERAL_LEDGER_NUM, AL1.PERFORMING_FLAG, AL2.INSURING_STATUS_STR 
FROM DW_INTERFACE.VW_LOANS AL1, DM_CAP.VW_LOANS_PROB_EO AL2 
WHERE ( AL1.ACCOUNT_NUM = AL2.ACCOUNT_NUM (+))  
AND (AL1.PROD_DATE='17-02-2009 00:00:00');



SELECT cardinality "Rows", lpad(' ',level-1)||operation||' '||options||' '||object_name "Plan", p.*
  FROM PLAN_TABLE p
CONNECT BY prior id = parent_id
        AND prior statement_id = statement_id
  START WITH id = 0
        AND statement_id = 'ktk'
  ORDER BY id;

set heading off;
set linesize 132;
set pagesize 132;
SELECT * FROM TABLE(dbms_xplan.display);
set heading on;
