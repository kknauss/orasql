SELECT * FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = 'SYSAUX' ORDER BY BYTES DESC;

SELECT * FROM DBA_SEGMENTS WHERE segment_name = 'AUD$' ORDER BY BYTES DESC;

--==============================================================================
--
--DW_FLATODS"."FLAT_ODS_LOAD_RUN"."S5_ML_FLAT_COLLATERAL
--
SELECT * FROM DBA_OBJECTS WHERE OWNER = 'DW_FLATODS' AND OBJECT_NAME = 'FLAT_ODS_LOAD_RUN';

SELECT * FROM DBA_SCHEDULER_JOBS WHERE JOB_NAME = 'FLAT_ODS_LOAD_RUN';

SELECT * FROM DBA_OBJECTS WHERE OWNER = 'DW_FLATODS' AND OBJECT_NAME = 'FLAT_ODS_LOAD';

SELECT * FROM DBA_SCHEDULER_CHAINS WHERE OWNER = 'DW_FLATODS' AND CHAIN_NAME = 'FLAT_ODS_LOAD';

SELECT * FROM DBA_SCHEDULER_CHAIN_STEPS WHERE OWNER = 'DW_FLATODS' AND CHAIN_NAME = 'FLAT_ODS_LOAD';

  SELECT * FROM DBA_SCHEDULER_CHAIN_STEPS WHERE OWNER = 'DW_FLATODS' AND CHAIN_NAME = 'ODS_CALCS';
  SELECT * FROM DBA_SCHEDULER_CHAIN_STEPS WHERE OWNER = 'DW_FLATODS' AND CHAIN_NAME = 'DDW_INTERFACES';
  SELECT * FROM DBA_SCHEDULER_CHAIN_STEPS WHERE OWNER = 'DW_FLATODS' AND CHAIN_NAME = 'FLATODS_MAIN_CHAIN';
  SELECT * FROM DBA_SCHEDULER_CHAIN_STEPS WHERE OWNER = 'DW_FLATODS' AND CHAIN_NAME = 'BRAV_REPURCHASE_CHAIN';

SELECT * FROM DBA_SCHEDULER_CHAIN_STEPS WHERE STEP_NAME = 'S5_ML_FLAT_COLLATERAL';

SELECT * FROM DBA_OBJECTS WHERE OWNER = 'DW_FLATODS' AND OBJECT_NAME = 'PR_LD_ML_FLAT_COLLATERAL';

SELECT * FROM DBA_SCHEDULER_PROGRAMS WHERE PROGRAM_NAME = 'PR_LD_ML_FLAT_COLLATERAL';