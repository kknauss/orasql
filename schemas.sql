select s.owner, round(sum(s.bytes)/1024/1024) sizeMB, u.created
from dba_segments s, dba_users u
where s.owner = u.username
and s.owner not in (
'APPQOSSYS',
'AQUSER',
'BACKUP',
--'DBAUDIT',
'CTXSYS',
'DBSNMP',
'DIP',
'EXFSYS',
'MGMT_VIEW',
'OUTLN',
'PERFSTAT',
'SYS',
'SYSTEM',
'TSMSYS',
'WMSYS',
'XDB' )
group by s.owner, u.created
order by u.created;

--der by s.owner
--der by sum(s.bytes) desc;
