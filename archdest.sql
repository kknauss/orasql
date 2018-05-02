column log_mode    format a12 ;
column schedule    format a12 ;
column destination format a48 ;

select log_mode, schedule, destination
from v$archive_dest ad, v$database d
where ad.destination is not null;
