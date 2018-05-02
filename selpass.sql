undef username;

select username, password, account_status, profile, created
from dba_users
where username like upper('&&username%')
order by username;

select username, password, account_status, lock_date, expiry_date, profile, created
from dba_users
where username = upper('&&username');
