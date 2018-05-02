select
	username, sid, serial#, decode(bitand(flag,268435456),268435456,'serializable','non-serializable')
from
	v$transaction,
	v$session
where
	taddr=addr;
