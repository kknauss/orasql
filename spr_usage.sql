/*
	Shared Pool Reserved Area usage

*/

--Free_space is INCORRECT... this is Bug 2627856
--select request_misses, free_space from v$shared_pool_reserved ;

--select request_misses, free_space, value as total_space, round(  (((value-free_space)/value)*100), 2) as pct_Used
--from v$shared_pool_reserved a, (select to_number(value) as value from v$parameter where name = 'shared_pool_reserved_size') b ;

select request_misses, freespace 
from v$shared_pool_reserved,
     (select sum(ksmchsiz)  as freespace from sys.x$ksmsp p where ksmchcls = 'R-free')
 ;


select request_misses, freespace, value as total_space, round(  (((value-freespace)/value)*100), 2) as pct_Used
from v$shared_pool_reserved a, 
     (select to_number(value) as value from v$parameter where name = 'shared_pool_reserved_size') b,
     (select sum(ksmchsiz)  as freespace from sys.x$ksmsp p where ksmchcls = 'R-free') c
;
