column "OS User"      format a8;
column "DB User"      format a8;
column "Schema"       format a8;
column "Object Name"  format a12;
column "RBS"          format a12;

--and SESSION_ID = 97

select  a.session_id
 , substr(a.os_user_name,1,8)    "OS User" 
 , substr(a.oracle_username,1,8) "DB User" 
       , substr(b.owner,1,8)  "Schema" 
 , substr(b.object_name,1,12)    "Object Name" 
    , substr(b.object_type,1,6)    "Type" 
       , substr(c.segment_name,1,12)  "RBS" 
       , substr(d.used_urec,1,8)      "# of Records" 
from v$locked_object      a 
     , dba_objects b 
     , dba_rollback_segs  c 
     , v$transaction      d 
 , v$session e 
where   a.object_id =  b.object_id 
 and a.xidusn    =  c.segment_id 
    and a.xidusn    =  d.xidusn 
    and a.xidslot   =  d.xidslot 
 and d.addr      =  e.taddr 
AND B.OBJECT_NAME like 'REPL_ITEM%'
; 

