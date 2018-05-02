set serveroutput on size 1000000;
set verify off;

DECLARE
    l_par_nbr       NUMBER       :=  &1 ;
    l_schema        VARCHAR2(32) := lower('&2');
    l_dp_dir        VARCHAR2(32) := upper('&3');
    l_obj_type      VARCHAR2(32) := upper('&4');
    l_obj_name      VARCHAR2(32) := upper('&5');
    
    l_job_handle    NUMBER;
    l_job_status    VARCHAR2(12);
    l_job_name      VARCHAR2(12);
BEGIN
    l_job_name := 'PAR' || to_char(l_par_nbr);
    
    l_job_handle := DBMS_DATAPUMP.OPEN(
                                    operation   => 'SQL_FILE',
                                    job_mode    => 'SCHEMA', 
                                    remote_link =>  NULL, 
                                    job_name    =>  l_job_name,
                                    version     => 'LATEST'
                               );
    DBMS_DATAPUMP.ADD_FILE(
                                    handle    =>  l_job_handle,
                                    filename  => 'PAR'||to_char(l_par_nbr)||'.'||lower(l_schema)||'.dmp',
                                    directory =>  l_dp_dir,
                                    filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_DUMP_FILE
                             );
                             
    DBMS_DATAPUMP.ADD_FILE(
                                handle    =>  l_job_handle,
                                filename  => 'PAR'||to_char(l_par_nbr)||'.'||lower(l_schema)||'.'||lower(l_obj_name)||'.log',
                                directory => l_dp_dir,
                                filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE); 
                                
    DBMS_DATAPUMP.ADD_FILE(
                                    handle    =>  l_job_handle,
                                    filename  => 'PAR'||to_char(l_par_nbr)||'.'||lower(l_schema)||'.'||lower(l_obj_name)||'.sql',
                                    directory =>  l_dp_dir,
                                    filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_SQL_FILE
                             );

/* Add procedures to our list of what we want to "import" (otw, we get everythin) */                              
    DBMS_DATAPUMP.METADATA_FILTER (
                                    handle => l_job_handle,
                                    name => 'INCLUDE_PATH_EXPR',
                                    value => 'IN ('''||l_obj_type||''')'
                                    );
                                     
/* Add specific procedure we want to our list (otw, we get all procedures) 
   (if we didn't do include_path_expr, we'd get everything exception procedures 
   with the excpetion of this explicity listed procedure) */
    DBMS_DATAPUMP.METADATA_FILTER(
                                    handle      =>  l_job_handle,
                                    name        => 'NAME_EXPR',
                                    value       => 'IN ('''||l_obj_name||''')',
                                    object_type =>  l_obj_type);
    
    DBMS_DATAPUMP.START_JOB(l_job_handle);

    DBMS_DATAPUMP.WAIT_FOR_JOB(l_job_handle,l_job_status);
     
    DBMS_OUTPUT.PUT_LINE('Job '||to_char(l_job_handle) ||' finished with status: '||l_job_status);
    
    DBMS_DATAPUMP.DETACH(l_job_handle);
EXCEPTION WHEN OTHERS 
THEN
        DBMS_DATAPUMP.DETACH(l_job_handle);
END;
/
