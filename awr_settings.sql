col snap_interval format a32;
col retention format a32;
select
       extract( day from snap_interval) *24*60+
       extract( hour from snap_interval) *60+
       extract( minute from snap_interval ) "Snapshot Interval (min)", snap_interval,
       extract( day from retention) *24*60+
       extract( hour from retention) *60+
       extract( minute from retention ) "Retention Interval (min)", retention
from dba_hist_wr_control where dbid = (select dbid from v$database);
