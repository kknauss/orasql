/*
 * grant read, write on directory TMP to knauss_dba;
 * grant exp_full_database to knauss_dba;
 * grant imp_full_database to knauss_dba;
 *
*/

whenever sqlerror continue
exec dbaudit.set_dba_role('PAR213986');

/* ***********
pause Press ENTER to continue ...

@expdp.norows.parms.sql 213986 DW_FACT      KTKTMP 0
@expdp.norows.parms.sql 213986 DW_INTERFACE KTKTMP 0
*********** */

pause Press ENTER to continue ...

@impdp.sqlfile.parms.sql 213986 DW_FACT      KTKTMP VIEW VW_OSI_LOAN_PARTL

@impdp.sqlfile.parms.sql 213986 DW_INTERFACE KTKTMP VIEW VW_LOANS

@impdp.sqlfile.parms.sql 213986 DW_INTERFACE KTKTMP VIEW VW_LOAN_PARTA

@impdp.sqlfile.parms.sql 213986 DW_INTERFACE KTKTMP VIEW VW_LOAN_END_STATE

@impdp.sqlfile.parms.sql 213986 DW_INTERFACE KTKTMP VIEW VW_LOANS_RECONCILED


@impdp.sqlfile.parms.sql 213986 DW_FACT      KTKTMP PACKAGE PKG_OSI_LOAN_LOAD

@impdp.sqlfile.parms.sql 213986 DW_FACT      KTKTMP PACKAGE PKG_LOAN_MONTHEND_LOAD

@impdp.sqlfile.parms.sql 213986 DW_FACT      KTKTMP PACKAGE PKG_LOAD_LOOKUP

@impdp.sqlfile.parms.sql 213986 DW_FACT      KTKTMP PACKAGE PKG_LOAN_LOAD