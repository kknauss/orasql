col SID format 99999;
col RECID format 99999 heading 'RecID';
col OPERATION format a48            heading 'Operation';
col STATUS format a24            heading 'Status';
col START_TIME format a17 heading 'Start Time'
col END_TIME format a17 heading 'End Time'
col INPUT_mb format 999999 heading 'Input|MB';
col OUTPUT_mb format 999999 heading 'Ouput|MB';
col OPTIMIZED format a3 heading 'Opt|?'
col OBJECT_TYPE format a13 heading 'Object Type';
col OUTPUT_DEVICE_TYPE format a7 heading 'Device|Type';

select
	SID,
	RECID,
	LPAD(' ',(LEVEL-1) * 3) || OPERATION as OPERATION,
	STATUS,
	to_char(START_TIME,'mm/dd/yy hh24:mi:ss') as START_TIME,
	to_char(END_TIME,'mm/dd/yy hh24:mi:ss') as END_TIME,
	INPUT_BYTES/(1024*1024) INPUT_mb,
	OUTPUT_BYTES/(1024*1024) OUTPUT_mb,
	OPTIMIZED,
	OBJECT_TYPE,
	OUTPUT_DEVICE_TYPE
from V$RMAN_STATUS 
connect by prior recid = parent_recid
start with recid in (select recid from v$rman_status where PARENT_RECID is null)
order siblings by recid;
