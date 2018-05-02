col current_scn format 999999999999999;

select name, log_mode, open_mode, current_scn, flashback_on
from v$database;

exit;
