select 
  n.name, t.value 
from 
  v$mystat   t join 
  v$statname n
on 
  t.statistic# = n.statistic#
where 
  n.name = 'redo size';
