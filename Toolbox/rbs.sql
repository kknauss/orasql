set pagesize 55;
set linesize 180;
column tablespace_name format a15;
column name format a15;
column status format a8;

select  NAME,
tablespace_name,
        a.USN,
        RSSIZE,
        OPTSIZE,
        HWMSIZE,
        EXTENDS,
        WRAPS,
        SHRINKS,
        AVESHRINK,
        AVEACTIVE,
        a.STATUS
from    v$rollstat a ,
        v$rollname b,
        dba_rollback_segs c
where   a.USN=b.USN
and a.usn = c.segment_id
order   by NAME;