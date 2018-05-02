column inst_id      format       9 heading 'In|st';
column sid          format  999999;
column serial#      format  999999 heading 'Serial#';
column sessstatus   format      a8 heading 'Session|Status';
column transtatus   format      a8 heading 'Trans-|action|Status';
column XID          format     a16 heading 'Transaction ID';
column start_time   format     a17 heading 'Start Time';
column used_ublk                   heading 'Undo|Blocks|Used';
column used_urec                   heading 'Undo|Records|Used';
column ublk_mb                     heading 'MB|Undo|Used';

SELECT s.INST_ID, SID, SERIAL#, s.STATUS sessstatus, t.STATUS transtatus, XID, START_TIME, USED_UBLK, USED_UREC,
      round(((t.USED_UBLK * (select value from v$parameter where name = 'db_block_size'))/(1024*1024)),2) as ublk_MB
FROM GV$SESSION s, GV$TRANSACTION t
WHERE s.INST_ID = t.INST_ID
AND s.TADDR = t.ADDR;
