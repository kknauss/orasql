SELECT * FROM DBA_HIST_SQLTEXT WHERE SQL_ID = '0bfzpvcjty0y5';

/*
Update Frequency can be 'H' or 'D'.  the create date changes every time it's basically the sysdate.
For the job that runs every 15 minutes we used 'H' for the update frequency.
*/
  SELECT LOANEVENTC0_.LOAN_EVENT_SUB_TYPE AS LOAN1_5_0_, LOANEVENTC0_.LOAN_EVENT_TYPE AS LOAN2_5_0_, LOANEVENTC0_.MTG_SK_SEQ AS MTG3_5_0_, LOANEVENTT1_.LOAN_EVENT_TYPE_SK_SEQ AS LOAN1_9_1_, LOANEVENTC0_.CREATE_DATE AS CREATE4_5_0_, LOANEVENTC0_.LOAN_EVENT_TYPE_SK_SEQ AS LOAN8_5_0_, LOANEVENTC0_.NEW_VALUE AS NEW5_5_0_, LOANEVENTC0_.OLD_VALUE AS OLD6_5_0_, LOANEVENTC0_.UPDATE_FREQUENCY AS UPDATE7_5_0_, LOANEVENTT1_.CREATE_DATE AS CREATE2_9_1_, LOANEVENTT1_.CREATE_EVENT_FLAG AS CREATE3_9_1_, LOANEVENTT1_.CREATE_USER AS CREATE4_9_1_, LOANEVENTT1_.DETAIL_LINK AS DETAIL5_9_1_, LOANEVENTT1_.LOAN_EVENT_TYPE AS LOAN6_9_1_, LOANEVENTT1_.EXP_DATE AS EXP7_9_1_, LOANEVENTT1_.LAST_BATCH_DATE AS LAST8_9_1_, LOANEVENTT1_.MODIFY_DATE AS MODIFY9_9_1_, LOANEVENTT1_.MODIFY_USER AS MODIFY10_9_1_, LOANEVENTT1_.REQUIRES_ACTION_FLAG AS REQUIRES11_9_1_, LOANEVENTT1_.REQUIRES_COC_FLAG AS REQUIRES12_9_1_, LOANEVENTT1_.RETAIL_DESCRIPTION AS RETAIL13_9_1_, LOANEVENTT1_.RETAIL_WHLSALE_TYPE AS RETAIL14_9_1_, LOANEVENTT1_.RUN_DATE AS RUN15_9_1_, LOANEVENTT1_.EMAIL_SEND_FLAG AS EMAIL16_9_1_, LOANEVENTT1_.STATUS_UPDATE_CODE AS STATUS17_9_1_, LOANEVENTT1_.STATUS_UPDATE_TYPE AS STATUS18_9_1_, LOANEVENTT1_.UPDATE_FREQUENCY AS UPDATE19_9_1_, LOANEVENTT1_.USER_MESSAGE AS USER20_9_1_, LOANEVENTT1_.WHOLESALE_DESCRIPTION AS WHOLESALE21_9_1_
    FROM BRAVURA.VW_LOAN_EVENT_CHANGES LOANEVENTC0_ INNER JOIN BRAVURA.LOAN_EVENT_TYPE LOANEVENTT1_
      ON LOANEVENTC0_.LOAN_EVENT_TYPE_SK_SEQ=LOANEVENTT1_.LOAN_EVENT_TYPE_SK_SEQ
   WHERE LOANEVENTC0_.UPDATE_FREQUENCY=:1
     AND LOANEVENTC0_.CREATE_DATE<:2
ORDER BY LOANEVENTC0_.MTG_SK_SEQ, LOANEVENTC0_.LOAN_EVENT_TYPE, LOANEVENTC0_.CREATE_DATE;

--BRAVURA.VW_LOAN_EVENT_CHANGES

BEGIN
  DBAUDIT.SET_DBA_ROLE('');
END;
/

WITH 
  TDLN_LOANS AS (SELECT A.MTG_SK_SEQ,
                   'TDLN' LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NEEDED' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'TDLN')
                      UPDATE_FREQUENCY
              FROM BRAVURA.VW_RETAIL_PROCESSING_QUE A, MTG_RETAIL_PROC_INFO B
             WHERE     A.MTG_SK_SEQ = B.MTG_SK_SEQ
                   AND B.DISCLOSURE_STATUS = 'DP'
                   AND TRUNC (DISCLOSURE_STATUS_DATE) < TRUNC (SYSDATE) - 14
                   AND bravura.pkg_loan_setup_action.sf_next_proc_status_date (
                          A.MTG_SK_SEQ,
                          '10DAYLTST',
                          DISCLOSURE_STATUS_DATE)
                          IS NULL),
  LOOKBACK_LOANS AS
        (SELECT /* INDEX(M IDX_MTG_APP_REG_DATE) */
          MTG_SK_SEQ, PROP_SK_SEQ
           FROM MORTGAGE M,
                CODE C
          WHERE M.RETAIL_WHLSALE_TYPE = 'R'
            AND C.CODE_TYPE = 'MTGPIPES'
            AND M.MTG_STATUS = C.CODE
            AND C.ORDER_BY_SEQ < 333
            AND M.APPL_REGISTER_DATE > SYSDATE - 545
            and exp_date is null),
  SNAPSHOT_LOANS AS (SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   CASE
                      --Strip out the last 4 on the Zip Code for comparison with addresses
                      WHEN LES.LOAN_EVENT_TYPE = 'ADDR'
                      THEN
                         REGEXP_REPLACE (TRIM (UPPER (LES.OLD_VALUE)),
                                         '([0-9]{5})(-)([0-9]{4})',
                                         '\1')
                      ELSE
                         UPPER (LES.OLD_VALUE)
                   END
                      OLD_VALUE,
                   CASE
                      WHEN LES.LOAN_EVENT_TYPE IN ('LAMT', 'LAMC')
                      THEN
                         TO_CHAR (MM.LOAN_AMT)
                      WHEN LES.LOAN_EVENT_TYPE IN
                              ('LSDF', 'LSET', 'LSEX', 'RSRL')
                      THEN
                         MLH.LOCK_STATUS
                      WHEN LES.LOAN_EVENT_TYPE IN ('INTR', 'INTC')
                      THEN
                         TO_CHAR (MM.INTEREST_RATE)
                      WHEN LES.LOAN_EVENT_TYPE IN ('PRIC')
                      THEN
                         TO_CHAR (MM.LOCK_DIFF_RATE)
                      WHEN LES.LOAN_EVENT_TYPE IN ('MPCH')
                      THEN
                         TO_CHAR (MM.MP_SK_SEQ)
                      WHEN LES.LOAN_EVENT_TYPE IN ('PURC')
                      THEN
                         TO_CHAR (P.PURCHASE_PRICE_AMT)
                      WHEN LES.LOAN_EVENT_TYPE IN ('APPV')
                      THEN
                         TO_CHAR (
                            BRAVURA.SF_GET_ACTIVE_APPRAISAL (P.PROP_SK_SEQ))
                      WHEN LES.LOAN_EVENT_TYPE IN ('ADDR')
                      THEN
                         --Strip out the last 4 on the Zip Code for comparison
                         REGEXP_REPLACE (
                            TRIM (
                               UPPER (
                                  LOS.SF_GET_PROPERTY_INFO (P.PROP_SK_SEQ,
                                                            'ALL'))),
                            '([0-9]{5})(-)([0-9]{4})',
                            '\1')
                   END
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM MORTGAGE M,
                   BRAVURA.LOAN_EVENT_SNAPSHOT LES,
                   MTG_MP MM,
                   MTG_LOCK_HIST MLH,
                   PROPERTY P
             WHERE     M.MTG_SK_SEQ = MM.MTG_SK_SEQ
                   AND MM.MTG_SK_SEQ = LES.MTG_SK_SEQ
                   AND MM.MTG_SK_SEQ = MLH.MTG_SK_SEQ
                   AND M.PROP_SK_SEQ = P.PROP_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE NOT IN ('FEEC', 'LOCK', 'LSDP', 'FCOC')
                   AND M.EXP_DATE IS NULL
                   AND MM.EXP_DATE IS NULL
                   AND MLH.EXP_DATE IS NULL
                   AND P.EXP_DATE IS NULL
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   '-999' OLD_VALUE,
                   TO_CHAR (MM.LOCK_DIFF_RATE) NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM BRAVURA.LOAN_EVENT_SNAPSHOT LES, MTG_MP MM
             WHERE     LES.MTG_SK_SEQ = MM.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE = 'LSDP'
                   AND MM.EXP_DATE IS NULL
                   AND LES.MTG_SK_SEQ IN
                          (SELECT LES2.MTG_SK_SEQ
                             FROM LOAN_EVENT_SNAPSHOT LES2,
                                  MTG_LOCK_HIST MLH2
                            WHERE     LES2.MTG_SK_SEQ = LES.MTG_SK_SEQ
                                  AND LES2.MTG_SK_SEQ = MLH2.MTG_SK_SEQ
                                  AND LES2.LOAN_EVENT_TYPE = 'LSDF'
                                  AND LES2.OLD_VALUE != MLH2.LOCK_STATUS)
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   TO_CHAR (
                      NVL (
                         BRAVURA.SF_GET_HUD_FEE (MMFS.MTG_SK_SEQ,
                                                 MMFS.MMP_SEQ_NUM,
                                                 MMFS.HUD_NUMBER),
                         0))
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM BRAVURA.LOAN_EVENT_SNAPSHOT LES, MTG_MP_FEE_SUMMARY MMFS
             WHERE     LES.MTG_SK_SEQ = MMFS.MTG_SK_SEQ
                   AND TO_NUMBER (LES.LOAN_EVENT_SUB_TYPE) = MMFS.HUD_NUMBER
                   AND LES.LOAN_EVENT_TYPE IN ('FEEC','FCOC')
            UNION
            SELECT MTG_SK_SEQ,
                   CASE
                      WHEN     OLD_VALUE = 'N'
                           AND NVL (
                                  LOS.SF_GET_PRODUCT_ANSWER (LES.MTG_SK_SEQ,
                                                             25060),
                                  'N') = 'Y'
                      THEN
                         'ESCR'
                      WHEN     OLD_VALUE = 'Y'
                           AND NVL (
                                  LOS.SF_GET_PRODUCT_ANSWER (LES.MTG_SK_SEQ,
                                                             25060),
                                  'N') = 'N'
                      THEN
                         'ESWR'
                   END
                      LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   NVL (LOS.SF_GET_PRODUCT_ANSWER (LES.MTG_SK_SEQ, 25060),
                        'N')
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM LOAN_EVENT_SNAPSHOT LES
             WHERE LES.LOAN_EVENT_TYPE = 'ESCR'
            UNION
            SELECT * FROM TDLN_LOANS
            UNION
            /* Begin 10 day letter needed req action*/
            SELECT A.MTG_SK_SEQ,
                   'LSQE' LOAN_EVENT_TYPE,
                   'DLN1' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NONE' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'LSQE')
                      UPDATE_FREQUENCY
              FROM TDLN_LOANS A
             WHERE bravura.pkg_loan_setup_action.sf_is_action_already_present (
                      A.mtg_sk_seq,
                      'DLN1') = 'N'
            UNION
            /* Begin 10 day follow up req action*/
            SELECT /* INDEX(MRPI PK_MRPI) */
                  M.MTG_SK_SEQ,
                   'LSQE' LOAN_EVENT_TYPE,
                   'LFUP' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NONE' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'LSQE')
                      UPDATE_FREQUENCY
              FROM LOOKBACK_LOANS M, MTG_RETAIL_PROC_INFO MRPI
             WHERE     m.MTG_SK_SEQ = MRPI.MTG_SK_SEQ
                   AND MRPI.PROCESSING_STATUS = '10DAYLTST'
                   AND TRUNC (
                          bravura.sf_find_nth_business_day3 (
                             (MRPI.PROCESSING_STATUS_DATE),
                             (BRAVURA.sf_get_system_preference (
                                 'CSC_ACTION_REQ',
                                 '10DAYLTST_DAYS')),
                             0)) <= TRUNC (SYSDATE)
                   AND bravura.pkg_loan_setup_action.sf_is_action_already_present (
                          m.mtg_sk_seq,
                          'LFUP') = 'N'
                   AND mrpi.exp_date IS NULL
            /* end 10 day follow up req action*/
            UNION
            /* Begin send approval letter  req action*/
            SELECT /* INDEX(MRPI PK_MRPI) */
                  M.MTG_SK_SEQ,
                   'LSQE' LOAN_EVENT_TYPE,
                   'SAPL' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NONE' NEW_VALUE,
                   bravura.pkg_loan_setup_action.sf_get_send_approval_ltr_date (
                      m.mtg_sk_seq)
                      CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'LSQE')
                      UPDATE_FREQUENCY
              FROM LOOKBACK_LOANS M, MTG_RETAIL_PROC_INFO MRPI
             WHERE     m.MTG_SK_SEQ = MRPI.MTG_SK_SEQ
                   AND bravura.pkg_loan_setup_action.sf_get_send_approval_ltr_date (
                          m.mtg_sk_seq)
                          IS NOT NULL
                   AND mrpi.exp_date IS NULL
            /* end send approval letter  req action*/
            UNION
            SELECT /* INDEX(MMU IDX_MMPUW_2) INDEX(P PK_PROP) INDEX(MRPI PK_MRPI) */
                  M.MTG_SK_SEQ,
                   'DEXP' LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   'NOTEXPIRING' OLD_VALUE,
                   'EXPIRING' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'DEXP')
                      UPDATE_FREQUENCY
              FROM LOOKBACK_LOANS M,
                   PROPERTY P,
                   MTG_RETAIL_PROC_INFO MRPI,
                   MTG_MP_UW MMU
             WHERE M.MTG_SK_SEQ = MRPI.MTG_SK_SEQ
                   AND M.PROP_SK_SEQ = P.PROP_SK_SEQ
                   AND M.MTG_SK_SEQ = MMU.MTG_SK_SEQ(+)
                   AND MRPI.EXP_DATE IS NULL
                   AND P.EXP_DATE IS NULL
                   AND MMU.EXP_DATE(+) IS NULL
                   AND (   TRUNC (
                              NVL (P.PUR_AGREEMENT_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.TITLE_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.CPL_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.SHORT_SALE_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.PAYOFF_LETTER_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MMU.UW_APPROV_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE))
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   DECODE (
                      LES.LOAN_EVENT_TYPE,
                      'BRNM', UPPER (B.FIRST_NAME || ' ' || B.LAST_NAME),
                      'BSSN', LPAD (B.SSN, 9, '0'))
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM MORTGAGE M,
                   BORR_MTG BM,
                   BORROWER B,
                   BRAVURA.LOAN_EVENT_SNAPSHOT LES
             WHERE     M.MTG_SK_SEQ = BM.MTG_SK_SEQ
                   AND B.BORR_SK_SEQ = BM.BORR_SK_SEQ
                   AND M.MTG_SK_SEQ = LES.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE IN ('BRNM', 'BSSN')
                   AND B.BORR_SK_SEQ = TO_NUMBER (LES.LOAN_EVENT_SUB_TYPE)
                   AND M.EXP_DATE IS NULL
                   AND BM.EXP_DATE IS NULL
                   AND B.EXP_DATE IS NULL
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   BRAVURA.SF_GET_ALL_BORR_SSN (M.MTG_SK_SEQ) NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM MORTGAGE M, BRAVURA.LOAN_EVENT_SNAPSHOT LES
             WHERE     M.MTG_SK_SEQ = LES.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE = 'BRCH'
                   AND M.EXP_DATE IS NULL
            UNION
            SELECT LH.MTG_SK_SEQ,
                   DECODE (
                      BRAVURA.SF_GET_LOAN_EVENT_LOCK_TYPE (LH.MTG_SK_SEQ,
                                                           LH.LH_SEQ_NUM),
                      'LOCKFLOAT', 'LKST',
                      'LOCK')
                      LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   'NOTLOCKED' OLD_VALUE,
                   'LOCKED' NEW_VALUE,
                   LH.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM LOCK_HISTORY LH, LOAN_EVENT_SNAPSHOT LES
             WHERE     LES.MTG_SK_SEQ = LH.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE = 'LOCK'
                   AND LH.LOCK_STATUS = 'LOCK'
                   AND TRUNC (LES.CREATE_DATE) = TRUNC (LH.CREATE_DATE)
                   AND BRAVURA.SF_GET_LOAN_EVENT_LOCK_TYPE (LH.MTG_SK_SEQ,
                                                            LH.LH_SEQ_NUM)
                          IS NOT NULL)
     SELECT SNAP.MTG_SK_SEQ,
            SNAP.LOAN_EVENT_TYPE,
            SNAP.LOAN_EVENT_SUB_TYPE,
            LET.LOAN_EVENT_TYPE_SK_SEQ,
            SNAP.CREATE_DATE,
            SNAP.OLD_VALUE,
            SNAP.NEW_VALUE,
            SNAP.UPDATE_FREQUENCY
       FROM MORTGAGE M, BRAVURA.LOAN_EVENT_TYPE LET, SNAPSHOT_LOANS SNAP
      WHERE     SNAP.MTG_SK_SEQ = M.MTG_SK_SEQ
            AND SNAP.LOAN_EVENT_TYPE = LET.LOAN_EVENT_TYPE
            AND TRIM (UPPER (SNAP.OLD_VALUE)) != TRIM (UPPER (SNAP.NEW_VALUE))
            AND (   LET.RETAIL_WHLSALE_TYPE = 'A'
                 OR LET.RETAIL_WHLSALE_TYPE =
                       WBCD.SF_GET_CONDITIONAL_BUS_CHNL (M.MTG_SK_SEQ))
            AND (   BRAVURA.SF_GET_FUNDED_DATE (M.MTG_SK_SEQ) IS NULL
                 OR SNAP.LOAN_EVENT_TYPE IN ('LAMC','INTC'))
            AND M.MTG_STATUS NOT IN ('CFIN', 'REJA', 'WITH', 'DENI')
            AND LET.EXP_DATE IS NULL
   ORDER BY 1, 2, 5;
   
   
--as inline view w/o hints
  SELECT LOANEVENTC0_.LOAN_EVENT_SUB_TYPE AS LOAN1_5_0_, LOANEVENTC0_.LOAN_EVENT_TYPE AS LOAN2_5_0_, LOANEVENTC0_.MTG_SK_SEQ AS MTG3_5_0_, LOANEVENTT1_.LOAN_EVENT_TYPE_SK_SEQ AS LOAN1_9_1_, LOANEVENTC0_.CREATE_DATE AS CREATE4_5_0_, LOANEVENTC0_.LOAN_EVENT_TYPE_SK_SEQ AS LOAN8_5_0_, LOANEVENTC0_.NEW_VALUE AS NEW5_5_0_, LOANEVENTC0_.OLD_VALUE AS OLD6_5_0_, LOANEVENTC0_.UPDATE_FREQUENCY AS UPDATE7_5_0_, LOANEVENTT1_.CREATE_DATE AS CREATE2_9_1_, LOANEVENTT1_.CREATE_EVENT_FLAG AS CREATE3_9_1_, LOANEVENTT1_.CREATE_USER AS CREATE4_9_1_, LOANEVENTT1_.DETAIL_LINK AS DETAIL5_9_1_, LOANEVENTT1_.LOAN_EVENT_TYPE AS LOAN6_9_1_, LOANEVENTT1_.EXP_DATE AS EXP7_9_1_, LOANEVENTT1_.LAST_BATCH_DATE AS LAST8_9_1_, LOANEVENTT1_.MODIFY_DATE AS MODIFY9_9_1_, LOANEVENTT1_.MODIFY_USER AS MODIFY10_9_1_, LOANEVENTT1_.REQUIRES_ACTION_FLAG AS REQUIRES11_9_1_, LOANEVENTT1_.REQUIRES_COC_FLAG AS REQUIRES12_9_1_, LOANEVENTT1_.RETAIL_DESCRIPTION AS RETAIL13_9_1_, LOANEVENTT1_.RETAIL_WHLSALE_TYPE AS RETAIL14_9_1_, LOANEVENTT1_.RUN_DATE AS RUN15_9_1_, LOANEVENTT1_.EMAIL_SEND_FLAG AS EMAIL16_9_1_, LOANEVENTT1_.STATUS_UPDATE_CODE AS STATUS17_9_1_, LOANEVENTT1_.STATUS_UPDATE_TYPE AS STATUS18_9_1_, LOANEVENTT1_.UPDATE_FREQUENCY AS UPDATE19_9_1_, LOANEVENTT1_.USER_MESSAGE AS USER20_9_1_, LOANEVENTT1_.WHOLESALE_DESCRIPTION AS WHOLESALE21_9_1_
    FROM (
    
    WITH 
  TDLN_LOANS AS (SELECT A.MTG_SK_SEQ,
                   'TDLN' LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NEEDED' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'TDLN')
                      UPDATE_FREQUENCY
              FROM BRAVURA.VW_RETAIL_PROCESSING_QUE A, MTG_RETAIL_PROC_INFO B
             WHERE     A.MTG_SK_SEQ = B.MTG_SK_SEQ
                   AND B.DISCLOSURE_STATUS = 'DP'
                   AND TRUNC (DISCLOSURE_STATUS_DATE) < TRUNC (SYSDATE) - 14
                   AND bravura.pkg_loan_setup_action.sf_next_proc_status_date (
                          A.MTG_SK_SEQ,
                          '10DAYLTST',
                          DISCLOSURE_STATUS_DATE)
                          IS NULL),
  LOOKBACK_LOANS AS
        (SELECT /* INDEX(M IDX_MTG_APP_REG_DATE) */
          MTG_SK_SEQ, PROP_SK_SEQ
           FROM MORTGAGE M,
                CODE C
          WHERE M.RETAIL_WHLSALE_TYPE = 'R'
            AND C.CODE_TYPE = 'MTGPIPES'
            AND M.MTG_STATUS = C.CODE
            AND C.ORDER_BY_SEQ < 333
            AND M.APPL_REGISTER_DATE > SYSDATE - 545
            and exp_date is null),
  SNAPSHOT_LOANS AS (SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   CASE
                      --Strip out the last 4 on the Zip Code for comparison with addresses
                      WHEN LES.LOAN_EVENT_TYPE = 'ADDR'
                      THEN
                         REGEXP_REPLACE (TRIM (UPPER (LES.OLD_VALUE)),
                                         '([0-9]{5})(-)([0-9]{4})',
                                         '\1')
                      ELSE
                         UPPER (LES.OLD_VALUE)
                   END
                      OLD_VALUE,
                   CASE
                      WHEN LES.LOAN_EVENT_TYPE IN ('LAMT', 'LAMC')
                      THEN
                         TO_CHAR (MM.LOAN_AMT)
                      WHEN LES.LOAN_EVENT_TYPE IN
                              ('LSDF', 'LSET', 'LSEX', 'RSRL')
                      THEN
                         MLH.LOCK_STATUS
                      WHEN LES.LOAN_EVENT_TYPE IN ('INTR', 'INTC')
                      THEN
                         TO_CHAR (MM.INTEREST_RATE)
                      WHEN LES.LOAN_EVENT_TYPE IN ('PRIC')
                      THEN
                         TO_CHAR (MM.LOCK_DIFF_RATE)
                      WHEN LES.LOAN_EVENT_TYPE IN ('MPCH')
                      THEN
                         TO_CHAR (MM.MP_SK_SEQ)
                      WHEN LES.LOAN_EVENT_TYPE IN ('PURC')
                      THEN
                         TO_CHAR (P.PURCHASE_PRICE_AMT)
                      WHEN LES.LOAN_EVENT_TYPE IN ('APPV')
                      THEN
                         TO_CHAR (
                            BRAVURA.SF_GET_ACTIVE_APPRAISAL (P.PROP_SK_SEQ))
                      WHEN LES.LOAN_EVENT_TYPE IN ('ADDR')
                      THEN
                         --Strip out the last 4 on the Zip Code for comparison
                         REGEXP_REPLACE (
                            TRIM (
                               UPPER (
                                  LOS.SF_GET_PROPERTY_INFO (P.PROP_SK_SEQ,
                                                            'ALL'))),
                            '([0-9]{5})(-)([0-9]{4})',
                            '\1')
                   END
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM MORTGAGE M,
                   BRAVURA.LOAN_EVENT_SNAPSHOT LES,
                   MTG_MP MM,
                   MTG_LOCK_HIST MLH,
                   PROPERTY P
             WHERE     M.MTG_SK_SEQ = MM.MTG_SK_SEQ
                   AND MM.MTG_SK_SEQ = LES.MTG_SK_SEQ
                   AND MM.MTG_SK_SEQ = MLH.MTG_SK_SEQ
                   AND M.PROP_SK_SEQ = P.PROP_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE NOT IN ('FEEC', 'LOCK', 'LSDP', 'FCOC')
                   AND M.EXP_DATE IS NULL
                   AND MM.EXP_DATE IS NULL
                   AND MLH.EXP_DATE IS NULL
                   AND P.EXP_DATE IS NULL
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   '-999' OLD_VALUE,
                   TO_CHAR (MM.LOCK_DIFF_RATE) NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM BRAVURA.LOAN_EVENT_SNAPSHOT LES, MTG_MP MM
             WHERE     LES.MTG_SK_SEQ = MM.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE = 'LSDP'
                   AND MM.EXP_DATE IS NULL
                   AND LES.MTG_SK_SEQ IN
                          (SELECT LES2.MTG_SK_SEQ
                             FROM LOAN_EVENT_SNAPSHOT LES2,
                                  MTG_LOCK_HIST MLH2
                            WHERE     LES2.MTG_SK_SEQ = LES.MTG_SK_SEQ
                                  AND LES2.MTG_SK_SEQ = MLH2.MTG_SK_SEQ
                                  AND LES2.LOAN_EVENT_TYPE = 'LSDF'
                                  AND LES2.OLD_VALUE != MLH2.LOCK_STATUS)
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   TO_CHAR (
                      NVL (
                         BRAVURA.SF_GET_HUD_FEE (MMFS.MTG_SK_SEQ,
                                                 MMFS.MMP_SEQ_NUM,
                                                 MMFS.HUD_NUMBER),
                         0))
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM BRAVURA.LOAN_EVENT_SNAPSHOT LES, MTG_MP_FEE_SUMMARY MMFS
             WHERE     LES.MTG_SK_SEQ = MMFS.MTG_SK_SEQ
                   AND TO_NUMBER (LES.LOAN_EVENT_SUB_TYPE) = MMFS.HUD_NUMBER
                   AND LES.LOAN_EVENT_TYPE IN ('FEEC','FCOC')
            UNION
            SELECT MTG_SK_SEQ,
                   CASE
                      WHEN     OLD_VALUE = 'N'
                           AND NVL (
                                  LOS.SF_GET_PRODUCT_ANSWER (LES.MTG_SK_SEQ,
                                                             25060),
                                  'N') = 'Y'
                      THEN
                         'ESCR'
                      WHEN     OLD_VALUE = 'Y'
                           AND NVL (
                                  LOS.SF_GET_PRODUCT_ANSWER (LES.MTG_SK_SEQ,
                                                             25060),
                                  'N') = 'N'
                      THEN
                         'ESWR'
                   END
                      LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   NVL (LOS.SF_GET_PRODUCT_ANSWER (LES.MTG_SK_SEQ, 25060),
                        'N')
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM LOAN_EVENT_SNAPSHOT LES
             WHERE LES.LOAN_EVENT_TYPE = 'ESCR'
            UNION
            SELECT * FROM TDLN_LOANS
            UNION
            /* Begin 10 day letter needed req action*/
            SELECT A.MTG_SK_SEQ,
                   'LSQE' LOAN_EVENT_TYPE,
                   'DLN1' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NONE' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'LSQE')
                      UPDATE_FREQUENCY
              FROM TDLN_LOANS A
             WHERE bravura.pkg_loan_setup_action.sf_is_action_already_present (
                      A.mtg_sk_seq,
                      'DLN1') = 'N'
            UNION
            /* Begin 10 day follow up req action*/
            SELECT /* INDEX(MRPI PK_MRPI) */
                  M.MTG_SK_SEQ,
                   'LSQE' LOAN_EVENT_TYPE,
                   'LFUP' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NONE' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'LSQE')
                      UPDATE_FREQUENCY
              FROM LOOKBACK_LOANS M, MTG_RETAIL_PROC_INFO MRPI
             WHERE     m.MTG_SK_SEQ = MRPI.MTG_SK_SEQ
                   AND MRPI.PROCESSING_STATUS = '10DAYLTST'
                   AND TRUNC (
                          bravura.sf_find_nth_business_day3 (
                             (MRPI.PROCESSING_STATUS_DATE),
                             (BRAVURA.sf_get_system_preference (
                                 'CSC_ACTION_REQ',
                                 '10DAYLTST_DAYS')),
                             0)) <= TRUNC (SYSDATE)
                   AND bravura.pkg_loan_setup_action.sf_is_action_already_present (
                          m.mtg_sk_seq,
                          'LFUP') = 'N'
                   AND mrpi.exp_date IS NULL
            /* end 10 day follow up req action*/
            UNION
            /* Begin send approval letter  req action*/
            SELECT /* INDEX(MRPI PK_MRPI) */
                  M.MTG_SK_SEQ,
                   'LSQE' LOAN_EVENT_TYPE,
                   'SAPL' LOAN_EVENT_SUB_TYPE,
                   'NOTNEEDED' OLD_VALUE,
                   'NONE' NEW_VALUE,
                   bravura.pkg_loan_setup_action.sf_get_send_approval_ltr_date (
                      m.mtg_sk_seq)
                      CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'LSQE')
                      UPDATE_FREQUENCY
              FROM LOOKBACK_LOANS M, MTG_RETAIL_PROC_INFO MRPI
             WHERE     m.MTG_SK_SEQ = MRPI.MTG_SK_SEQ
                   AND bravura.pkg_loan_setup_action.sf_get_send_approval_ltr_date (
                          m.mtg_sk_seq)
                          IS NOT NULL
                   AND mrpi.exp_date IS NULL
            /* end send approval letter  req action*/
            UNION
            SELECT /* INDEX(MMU IDX_MMPUW_2) INDEX(P PK_PROP) INDEX(MRPI PK_MRPI) */
                  M.MTG_SK_SEQ,
                   'DEXP' LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   'NOTEXPIRING' OLD_VALUE,
                   'EXPIRING' NEW_VALUE,
                   TRUNC (SYSDATE) CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = 'DEXP')
                      UPDATE_FREQUENCY
              FROM LOOKBACK_LOANS M,
                   PROPERTY P,
                   MTG_RETAIL_PROC_INFO MRPI,
                   MTG_MP_UW MMU
             WHERE M.MTG_SK_SEQ = MRPI.MTG_SK_SEQ
                   AND M.PROP_SK_SEQ = P.PROP_SK_SEQ
                   AND M.MTG_SK_SEQ = MMU.MTG_SK_SEQ(+)
                   AND MRPI.EXP_DATE IS NULL
                   AND P.EXP_DATE IS NULL
                   AND MMU.EXP_DATE(+) IS NULL
                   AND (   TRUNC (
                              NVL (P.PUR_AGREEMENT_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.TITLE_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.CPL_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.SHORT_SALE_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MRPI.PAYOFF_LETTER_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE)
                        OR TRUNC (
                              NVL (MMU.UW_APPROV_EXP_DATE,
                                   TO_DATE ('01/01/1900', 'MM/DD/YYYY'))) =
                              TRUNC (SYSDATE))
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   DECODE (
                      LES.LOAN_EVENT_TYPE,
                      'BRNM', UPPER (B.FIRST_NAME || ' ' || B.LAST_NAME),
                      'BSSN', LPAD (B.SSN, 9, '0'))
                      NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM MORTGAGE M,
                   BORR_MTG BM,
                   BORROWER B,
                   BRAVURA.LOAN_EVENT_SNAPSHOT LES
             WHERE     M.MTG_SK_SEQ = BM.MTG_SK_SEQ
                   AND B.BORR_SK_SEQ = BM.BORR_SK_SEQ
                   AND M.MTG_SK_SEQ = LES.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE IN ('BRNM', 'BSSN')
                   AND B.BORR_SK_SEQ = TO_NUMBER (LES.LOAN_EVENT_SUB_TYPE)
                   AND M.EXP_DATE IS NULL
                   AND BM.EXP_DATE IS NULL
                   AND B.EXP_DATE IS NULL
            UNION
            SELECT LES.MTG_SK_SEQ,
                   LES.LOAN_EVENT_TYPE,
                   LES.LOAN_EVENT_SUB_TYPE,
                   LES.OLD_VALUE,
                   BRAVURA.SF_GET_ALL_BORR_SSN (M.MTG_SK_SEQ) NEW_VALUE,
                   LES.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM MORTGAGE M, BRAVURA.LOAN_EVENT_SNAPSHOT LES
             WHERE     M.MTG_SK_SEQ = LES.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE = 'BRCH'
                   AND M.EXP_DATE IS NULL
            UNION
            SELECT LH.MTG_SK_SEQ,
                   DECODE (
                      BRAVURA.SF_GET_LOAN_EVENT_LOCK_TYPE (LH.MTG_SK_SEQ,
                                                           LH.LH_SEQ_NUM),
                      'LOCKFLOAT', 'LKST',
                      'LOCK')
                      LOAN_EVENT_TYPE,
                   'NONE' LOAN_EVENT_SUB_TYPE,
                   'NOTLOCKED' OLD_VALUE,
                   'LOCKED' NEW_VALUE,
                   LH.CREATE_DATE,
                   (SELECT UPDATE_FREQUENCY
                      FROM LOAN_EVENT_TYPE
                     WHERE LOAN_EVENT_TYPE = LES.LOAN_EVENT_TYPE)
                      UPDATE_FREQUENCY
              FROM LOCK_HISTORY LH, LOAN_EVENT_SNAPSHOT LES
             WHERE     LES.MTG_SK_SEQ = LH.MTG_SK_SEQ
                   AND LES.LOAN_EVENT_TYPE = 'LOCK'
                   AND LH.LOCK_STATUS = 'LOCK'
                   AND TRUNC (LES.CREATE_DATE) = TRUNC (LH.CREATE_DATE)
                   AND BRAVURA.SF_GET_LOAN_EVENT_LOCK_TYPE (LH.MTG_SK_SEQ,
                                                            LH.LH_SEQ_NUM)
                          IS NOT NULL)
     SELECT SNAP.MTG_SK_SEQ,
            SNAP.LOAN_EVENT_TYPE,
            SNAP.LOAN_EVENT_SUB_TYPE,
            LET.LOAN_EVENT_TYPE_SK_SEQ,
            SNAP.CREATE_DATE,
            SNAP.OLD_VALUE,
            SNAP.NEW_VALUE,
            SNAP.UPDATE_FREQUENCY
       FROM MORTGAGE M, BRAVURA.LOAN_EVENT_TYPE LET, SNAPSHOT_LOANS SNAP
      WHERE     SNAP.MTG_SK_SEQ = M.MTG_SK_SEQ
            AND SNAP.LOAN_EVENT_TYPE = LET.LOAN_EVENT_TYPE
            AND TRIM (UPPER (SNAP.OLD_VALUE)) != TRIM (UPPER (SNAP.NEW_VALUE))
            AND (   LET.RETAIL_WHLSALE_TYPE = 'A'
                 OR LET.RETAIL_WHLSALE_TYPE =
                       WBCD.SF_GET_CONDITIONAL_BUS_CHNL (M.MTG_SK_SEQ))
            AND (   BRAVURA.SF_GET_FUNDED_DATE (M.MTG_SK_SEQ) IS NULL
                 OR SNAP.LOAN_EVENT_TYPE IN ('LAMC','INTC'))
            AND M.MTG_STATUS NOT IN ('CFIN', 'REJA', 'WITH', 'DENI')
            AND LET.EXP_DATE IS NULL
   ORDER BY 1, 2, 5
    
    ) LOANEVENTC0_ INNER JOIN BRAVURA.LOAN_EVENT_TYPE LOANEVENTT1_
      ON LOANEVENTC0_.LOAN_EVENT_TYPE_SK_SEQ=LOANEVENTT1_.LOAN_EVENT_TYPE_SK_SEQ
   WHERE LOANEVENTC0_.UPDATE_FREQUENCY=:1
     AND LOANEVENTC0_.CREATE_DATE<:2
ORDER BY LOANEVENTC0_.MTG_SK_SEQ, LOANEVENTC0_.LOAN_EVENT_TYPE, LOANEVENTC0_.CREATE_DATE;


select sysdate from dual;

select * from gv$instance where startup_time > :1;


select * from v$access;