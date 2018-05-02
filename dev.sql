col username format a24
col created format a10
col profile format a24
col initial_rsrc_consumer_group format a24

select username, to_char(created, 'yyyy-mm-dd') created, profile, INITIAL_RSRC_CONSUMER_GROUP
from dba_users
where username like '%\_DEV' escape '\'
order by created;
