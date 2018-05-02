select obj#, object_name
from sys.scheduler$_job, dba_objects
where obj# = object_id
and obj# = &jobnbr;
