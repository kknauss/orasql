COMPUTE SUM LABEL 'Total' OF cnt ON report;

break on report;

select owner, count(*) cnt
from dba_indexes
group by  owner, status
order by  owner, status ;

clear breaks;
