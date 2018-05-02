/*
select inst_id, usn, rssize, wraps, xacts, OPTSIZE, HWMSIZE, STATUS
from gv$rollstat;

select rs.inst_id, rs.usn, rn.name, rs.rssize/(1024*1024) sizeMB, rs.wraps, rs.xacts, rs.OPTSIZE, rs.HWMSIZE, rs.STATUS, rs.shrinks
from gv$rollstat rs, v$rollname rn
where rs.usn = rn.usn;
*/

SELECT TABLESPACE_NAME, ROUND(SUM(BYTES)/POWER(1024,3),2) GB, COUNT(*) NBR_SEGMENTS
FROM DBA_SEGMENTS
WHERE SEGMENT_TYPE IN ('ROLLBACK','TYPE2 UNDO')
GROUP BY TABLESPACE_NAME;

select rs.inst_id, rs.usn, rn.name, round(rs.rssize/(1024*1024),2) sizeMB, rs.wraps, rs.xacts, rs.OPTSIZE, rs.HWMSIZE, rs.STATUS, rs.shrinks, round(s.bytes/(1024*1024),2) seg_sizeMB
from gv$rollstat rs, v$rollname rn, dba_segments s
where rs.usn = rn.usn
and rn.name = s.segment_name;
