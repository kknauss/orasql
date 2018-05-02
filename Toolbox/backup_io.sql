--DISK devices...
select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec, a.* from v$backup_async_io a order by set_count

--SBT_TAPE devices...
select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec, a.* from v$backup_sync_io a order by set_count


--
--
--select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec, b.*, a.*
select a.effective_bytes_per_second/(1024*1024) as effective_MB_persec,a.effective_bytes_per_second, a.device_type, b.handle, a.status, b.status, b.start_time, b.completion_time
from v$backup_sync_io a, v$backup_piece b
where a.set_stamp = b.set_stamp
and a.set_count = b.set_count
and a.filename like '%.lvl%bkup'
--and a.filename like '%.archbkup'
and to_date(substr(b.tag,4,8),'yyyymmdd') > sysdate - 1
order by a.set_count;
