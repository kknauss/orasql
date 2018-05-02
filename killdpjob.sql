undef dp_job_nm
undef dp_job_ownr

SET SERVEROUTPUT ON;

DECLARE
	h1 NUMBER;
BEGIN
	--Format: DBMS_DATAPUMP.ATTACH('[job_name]','[owner_name]');

	h1 := DBMS_DATAPUMP.ATTACH('&dp_job_nm','&dp_job_ownr');

	DBMS_DATAPUMP.STOP_JOB (h1,1,0);
END;
/
