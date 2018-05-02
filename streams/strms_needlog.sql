set serveroutput on size 1000000;

alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';

DECLARE
    lScn number := 0;
    alog varchar2(1000);
begin
    select min(required_checkpoint_scn)
    into lScn
    from dba_capture 
    where capture_name='MTR_DW_CAPTURE' ;
    
    dbms_output.put_line('Capture will restart from SCN ' || lScn ||' in the following file:');
    
    for cr in (select name, first_time from DBA_REGISTERED_ARCHIVED_LOG where lScn between first_scn and next_scn order by thread#)
    loop
        dbms_output.put_line(cr.name||' ('||cr.first_time||')');
    end loop;
end;
/
