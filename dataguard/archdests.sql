set numwidth 8 lines 100
column id format 99 
select	dest_id id
,	status
,	archiver
,	transmit_mode
,	affirm
,	async_blocks async
,	net_timeout net_time
,	delay_mins delay
,	reopen_secs reopen
,	register,binding 
from	v$archive_dest
order by
	dest_id;
