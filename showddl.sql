column text format a132;

select line, text
from dba_source
where owner = upper('&owner')
and name = upper('&objname')
order by line;
