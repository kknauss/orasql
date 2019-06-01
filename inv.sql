COLUMN OWNER FORMAT a24
COMPUTE SUM LABEL 'Total' OF cnt ON report;

break on report;

select owner, status, count(*) cnt
from dba_objects
where status <> 'VALID'
group by  owner, status
order by  owner, status ;

clear breaks;
