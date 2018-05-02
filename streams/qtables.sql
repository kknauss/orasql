col OWNER               format a16 heading 'Owner'
col QUEUE_TABLE         format a28 heading 'Queue Table'
col TYPE                format  a9 heading 'User|Data Type'
col OBJECT_TYPE         format a45 heading 'Object type when type=OBJECT'
col SORT_ORDER          format a12 heading 'Sort Order'
col RECIPIENTS          format a10 heading 'Recipients'
col MESSAGE_GROUPING    format a14 heading 'Message|Grouping'
col COMPATIBLE          format a10 heading 'Compatible'
col PRIMARY_INSTANCE    format  09 heading 'Prmy|Inst'
col SECONDARY_INSTANCE  format  09 heading 'Sdry|Inst'
col OWNER_INSTANCE      format  09 heading 'Ownr|Inst'
col SECURE              format  a6 heading 'Secure|?'
col USER_COMMENT        format a45 heading 'User Comment'

select
OWNER,
QUEUE_TABLE,
TYPE,
OBJECT_TYPE,
SORT_ORDER,
RECIPIENTS,
MESSAGE_GROUPING,
COMPATIBLE,
PRIMARY_INSTANCE,
SECONDARY_INSTANCE,
OWNER_INSTANCE,
SECURE,
USER_COMMENT
from dba_queue_tables;
