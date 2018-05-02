column new_pass new_value newpass;

set termout off;
select lower ( 'kk' || to_char(sysdate,'mmdd') || substr('&&username',1,2) ) new_pass from dual;
set verify on;
set termout on;


/* ************* */
select '
Hello,

Your password for '||name||' has been changed:

Username:      &&username
New password:  &newpass

Thanks,' emailtext from v$database;


/* ************* */
select 'Password changed for Oracle account &&username in database '||name||'.  Password emailed directly to user.' tickettext from v$database;




pause Press ENTER to change password ...

--ter user &&username identified by &newpass account unlock password expire;
alter user &&username identified by &newpass account unlock ;
