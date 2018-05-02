COLUMN DB_NAME FORMAT A12             HEADING 'Source DB';
COLUMN SRC_SCN FORMAT 999999999999999 HEADING 'Source DB SCN';
COLUMN SRC_TS  format a32             HEADING 'Source DB timestamp';
COLUMN TGT_SCN FORMAT 999999999999999 HEADING 'Target DB SCN';
COLUMN TGT_TS  format a32             HEADING 'Target DB timestamp';
column diff    format a32             heading 'Source-Target|Differential';
column diff2   format a32             heading 'Current Timestamp|Differential';

select apply_name, status, status_change_time from dba_apply;
select capture_name, status, status_change_time from dba_capture;
select propagation_name, status from dba_propagation;

select * from (
select DB_NAME, SRC_SCN, SRC_TS, TGT_SCN, TGT_TS, TGT_TS-SRC_TS diff, systimestamp-TGT_TS diff2
from STREAMS_ADMIN.STREAMS_HEARTBEAT_MONITOR 
order by TGT_SCN desc
) 
where rownum < 6;
