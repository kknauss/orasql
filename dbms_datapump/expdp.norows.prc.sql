set serveroutput on size 1000000;
set verify off;
 

create or replace procedure kknauss.expdp_schema(p_PARNBR number, p_DIR varchar2, p_SCHEMA varchar2, p_INCL_ROWS number)
AS
    l_job_handle NUMBER;
    l_job_status VARCHAR2(12);
    l_job_name VARCHAR2(12);
BEGIN
    l_job_name := 'PAR' || to_char(p_PARNBR);

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
                                filename  => 'PAR'||to_char(p_PARNBR)||'.'||p_SCHEMA||'.dmp',
                                directory => p_DIR,
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_DUMP_FILE);

    DBMS_DATAPUMP.ADD_FILE(
                                handle    =>  l_job_handle,
                                filename  => 'PAR'||to_char(p_PARNBR)||'.'||p_SCHEMA||'.log',
                                directory => p_DIR,
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);    

    -- A metadata filter is used to specify the schema that will be exported.
    DBMS_DATAPUMP.METADATA_FILTER(l_job_handle,'SCHEMA_EXPR','IN (upper('''||p_SCHEMA||'''))');
            
    --No rows export
    DBMS_DATAPUMP.DATA_FILTER ( l_job_handle, 'INCLUDE_ROWS', p_INCL_ROWS);

    -- Start the job. An exception will be generated if something is not set up properly. 
    DBMS_DATAPUMP.START_JOB(l_job_handle);
    
    DBMS_DATAPUMP.WAIT_FOR_JOB(l_job_handle,l_job_status);
     
    DBMS_OUTPUT.PUT_LINE('Job '||to_char(l_job_handle) ||' finished with status: '||l_job_status);
    
    DBMS_DATAPUMP.DETACH(l_job_handle);
END;
/

set serveroutput on size 1000000; 
exec kknauss.expdp_schema(12346, 'DATA_PUMP_DIR', 'LOS', 0);
