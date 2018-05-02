select *
from your_table
where a=1
and b=2
;

  delete from 
mytable
where 1=1;

	update mytable
set a=1, b=2, c=3
where a > 3
;	-- something else

	update mytable
set a=1
where a > 3
;	-- something else


delete 
yourtable
where a in (select A from mytable
);
