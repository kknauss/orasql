--http://www.oracle.com/technology/products/manageability/database/pdf/twp03/PPT_active_session_history.pdf
--page 23
--Returns most active SQL in the past minute
select sql_id, count(*), round(count(*) / sum(count(*)) over (), 2) pctload
from v$active_session_history
where sample_time > sysdate - 1/24/60
--where sample_time > sysdate - 1/24
--and session_type <> 'BACKGROUND'
group by sql_id 
order by count(*) desc;
