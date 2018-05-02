set serveroutput on size 1000000;
set verify off;

DECLARE
    l_par_nbr    NUMBER       :=  &1 ;
    l_schema     VARCHAR2(32) := lower('&2');
    l_dp_dir     VARCHAR2(32) := upper('&3');
    l_inclrows   NUMBER       :=  &4 ;
    
    l_job_handle NUMBER;
    l_job_status VARCHAR2(12);
    l_job_name VARCHAR2(12);
BEGIN
    l_job_name := 'PAR' || to_char(l_par_nbr);

    -- Create a (user-named) Data Pump job to do a schema export.
    l_job_handle := DBMS_DATAPUMP.OPEN(
                                    operation   => 'EXPORT',
                                    job_mode    => 'SCHEMA', 
                                    remote_link =>  NULL,
                                    job_name    =>  l_job_name,
                                    version     => 'LATEST'
                               );

    -- Specify a single dump file for the job (using the handle just returned)
    -- and a directory object, which must already be defined and accessible
    -- to the user running this procedure.
    DBMS_DATAPUMP.ADD_FILE(
                                handle    =>  l_job_handle,
                                filename  => 'PAR'||to_char(l_par_nbr)||'.'||lower(l_schema)||'.dmp',
                                directory =>  l_dp_dir,
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_DUMP_FILE);

    DBMS_DATAPUMP.ADD_FILE(
                                handle    =>  l_job_handle,
                                filename  => 'PAR'||to_char(l_par_nbr)||'.'||lower(l_schema)||'.log',
                                directory => l_dp_dir,
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);    

    -- A metadata filter is used to specify the schema that will be exported.
    DBMS_DATAPUMP.METADATA_FILTER(l_job_handle,'SCHEMA_EXPR','IN (upper('''||l_schema||'''))');
            
    --No rows export
    DBMS_DATAPUMP.DATA_FILTER ( l_job_handle, 'INCLUDE_ROWS', l_inclrows);

    -- Start the job. An exception will be generated if something is not set up properly. 
    DBMS_DATAPUMP.START_JOB(l_job_handle);
    
    DBMS_DATAPUMP.WAIT_FOR_JOB(l_job_handle,l_job_status);
     
    DBMS_OUTPUT.PUT_LINE('Job '||to_char(l_job_handle) ||' finished with status: '||l_job_status);
    
    DBMS_DATAPUMP.DETACH(l_job_handle);
EXCEPTION WHEN OTHERS 
THEN
        DBMS_DATAPUMP.DETACH(l_job_handle);
END;
/