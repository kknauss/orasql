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


SELECT G.INST_ID, G.SID,  G.CAPTURE_NAME, G.STARTUP_TIME, G.STATE, G.TOTAL_MESSAGES_CAPTURED,  G.CAPTURE_TIME, G.CAPTURE_MESSAGE_NUMBER, G.CAPTURE_MESSAGE_CREATE_TIME, 
   G.TOTAL_MESSAGES_CREATED,  G.TOTAL_MESSAGES_ENQUEUED, 
   G.ENQUEUE_TIME, G.ENQUEUE_MESSAGE_NUMBER, G.ENQUEUE_MESSAGE_CREATE_TIME, 
   G.ELAPSED_CAPTURE_TIME, 
   G.ELAPSED_RULE_TIME, G.ELAPSED_ENQUEUE_TIME, G.ELAPSED_LCR_TIME, 
   G.ELAPSED_REDO_WAIT_TIME, G.ELAPSED_PAUSE_TIME, G.STATE_CHANGED_TIME
FROM SYS.GV_$STREAMS_CAPTURE G;

select name,first_change#
from gv$archived_log a
where first_change# >= (select capture_message_number from gv$streams_capture)
and  inst_id=1
order by first_change#;




select name, first_change#, next_change#, capture_message_number, ((capture_message_number-first_change#)/(next_change#-first_change#))*100 "Progress thru logfile"
from gv$archived_log a, gv$streams_capture
where capture_message_number between first_change# and next_change#
and  a.inst_id=1
order by first_change#;




select * from STREAMS_ADMIN.STREAMS_HEARTBEAT_MONITOR order by TGT_SCN desc;
select * from v$instance;
select * from dba_capture;
select * from dba_propagation;
select * from dba_apply;
select * from dba_apply_error;