set serveroutput on size 1000000;
set verify off;

DECLARE
    h1 NUMBER;
    job_end_status VARCHAR2(12);
BEGIN
    -- Create a (user-named) Data Pump job to do a schema export.
    h1 := DBMS_DATAPUMP.OPEN(
                                    operation   => 'EXPORT',
                                    job_mode    => 'SCHEMA', 
                                    remote_link =>  NULL, 
                                    job_name    => 'PAR&&parnbr',
                                    version     => 'LATEST'
                               );

    -- Specify a single dump file for the job (using the handle just returned)
    -- and a directory object, which must already be defined and accessible
    -- to the user running this procedure.
    DBMS_DATAPUMP.ADD_FILE(
                                handle    =>  h1,
                                filename  => 'PAR&&parnbr..&&schema..dmp',
                                directory => 'DATA_PUMP_DIR',
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_DUMP_FILE);

    DBMS_DATAPUMP.ADD_FILE(
                                handle    =>  h1,
                                filename  => 'PAR&&parnbr..&&schema..expdp.log',
                                directory => 'DATA_PUMP_DIR',
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);    

    -- A metadata filter is used to specify the schema that will be exported.
    DBMS_DATAPUMP.METADATA_FILTER(h1,'SCHEMA_EXPR','IN (upper(''&&schema''))');
        
    --No rows export
    DBMS_DATAPUMP.DATA_FILTER ( h1, 'INCLUDE_ROWS', 0);

    -- Start the job. An exception will be generated if something is not set up properly. 
    DBMS_DATAPUMP.START_JOB(h1);
    
    DBMS_DATAPUMP.WAIT_FOR_JOB(h1,job_end_status);
     
    DBMS_OUTPUT.PUT_LINE('Job '||to_char(h1) ||' finished with status: '||job_end_status);
    
    DBMS_DATAPUMP.DETACH(h1);
END;
/