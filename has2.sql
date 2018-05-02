col username format a30;
col password format a32;
--Is the XS$NULL user a required account? (Doc ID 1556725.1)

--XS$NULL is an internal account used by APEX and XDB when no user session exists.
--It cannot be logged into, and the password cannot be changed; therefore, we
--ignore it in the following query.

select username,account_status, lock_date, expiry_date, password
from dba_users
where username in (SELECT username FROM dba_users_with_defpwd where username <> 'XS$NULL')
order by username;

exit;
