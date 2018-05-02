column member format a48;

select l.group#, l.thread#, l.bytes/1024/1024 sizeMB, l.blocksize, l.archived, l.status, lf.type, lf.member, LF.IS_RECOVERY_DEST_FILE
from v$log l, v$logfile lf
where l.group# = lf.group#
order by l.group#, l.thread#;
