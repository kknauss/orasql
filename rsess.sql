set verify off;

column spid                  heading 'Server|PID';
column server                heading 'Server|Type';
column last_call_et          heading 'Last Call|Elap(sec)';
column event    format a30   heading 'Wait Event';
column machine  format a22   heading 'Machine';
column program  format a22   heading 'Program';
column username format a13   heading 'Username';
column status   format  a8   heading 'Status';
column sql_text format a40   heading 'SQL Text';


select *
from gv$rsrc_session_info
where inst_id = &&inst_id
and sid = &&sid;
