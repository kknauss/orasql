select 'run' from dual;
select '{' from dual;
select 'allocate channel t1 type ''sbt_tape'' parms ''ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo_bormspr0.opt)'';' from dual;
select 'allocate channel t2 type ''sbt_tape'' parms ''ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo_bormspr0.opt)'';' from dual;

/*
 * This will generate backup backupset statements for archive 
 * log numbers 2326 - 2380 that are not already on tape.
 */
select distinct 'BACKUP BACKUPSET '||a.bs_key||' format ''%d_%t_%U.bsetbkup'';' AS BS_KEY
from rc_backup_redolog a, rc_database b
where a.db_key = b.db_key
and sequence# between 2112 and 2275
and b.name = 'BORMSPR0'
and not exists (select 1 from rc_backup_piece c where c.bs_key = a.bs_key and c.DEVICE_TYPE = 'SBT_TAPE')
order by bs_key;

/* */
select 'release  channel t1;' from dual;
select 'release  channel t2;' from dual;
select '}' from dual;

/* 
 * Backup Set Keys do not "increment" relative to, say, the archive logs.
 * BS_KEY 4316002 contains archive log sequences# 2376 - 2379, but BS_KEY
 * 4316003 contains 2372 - 2375.
 */
select * from rc_backup_piece   where bs_key = 4316002;
select * from rc_backup_redolog where bs_key = 4316002;
select * from rc_database where name = 'BORDWPR0';


select sequence#, first_time, first_change#, round((blocks*block_size)/(1024*1024),0) as sizeMB 
from rc_backup_redolog 
where db_key = 4107691
and sequence# > 5714
and sequence# < 5771 
order by sequence#;

select round((blocks*block_size)/(1024*1024),0) as sizeMB, count(*) 
from rc_backup_redolog 
where db_key = 4107691
and sequence# > 5713
and sequence# < 5771
group by round((blocks*block_size)/(1024*1024),0);

rc_backup_piece

select bs_key, device_type from rc_backup_piece where bs_key in 
( select distinct bs_key  from rc_backup_redolog where db_key = 4107691 and sequence# > 5309 )
order by bs_key, device_type;

and first_change# > 21530554941   
 and first_time > '18-SEP-05' 

/*
 * I used this to find the log sequence# based on the change# that I'd 
 * need to apply changes to a level 0 backup (using the checkpoint scn
 * from rman/list backup command.
 */
select a.sequence#, a.first_change#, a.first_time
from rc_backup_redolog a, rc_database b
where a.db_key = b.db_key
and b.name = 'BORMSPR0'
order by a.sequence#;

select count(*) 
from rc_backup_redolog a, rc_database b
where a.db_key = b.db_key
and b.name = 'BORMSPR0'
and a.sequence# between 2232 and 2380
order by a.sequence#;



/*
 * Generate backup backupset statements for all backupsets 
 * not yet on disk.
 */
select 'BACKUP BACKUPSET '||a.bs_key||' format ''%d_%t_%U.bsetbkup'';' AS BS_KEY
from rc_backup_piece a, rc_database b
where a.db_key = b.db_key
and b.name = 'BORMSPR0'
and not exists (select 1 from rc_backup_piece c where c.bs_key = a.bs_key and c.DEVICE_TYPE = 'SBT_TAPE')
order by bs_key;

/*
 * Generate delete backuppiece statements for all backuppieces on disk 
 * that have copies on tape and are over 10 days old.
 */
select 'DELETE BACKUPPIECE '||a.bp_key||';' AS BP_KEY
from rc_backup_piece a, rc_database b
where a.db_key = b.db_key
and b.name = 'BORMSPR0'
and a.COMPLETION_TIME < SYSDATE-10
and a.DEVICE_TYPE = 'DISK'
and exists (select 1 from rc_backup_piece c where c.bs_key = a.bs_key and c.DEVICE_TYPE = 'SBT_TAPE')
order by bs_key;

/*
 */
select 'ls -l '||a.handle||';' AS BP_KEY
from rc_backup_piece a, rc_database b
where a.db_key = b.db_key
and b.name = 'BORMSPR0'
and a.COMPLETION_TIME < SYSDATE-10
and a.DEVICE_TYPE = 'DISK'
and exists (select 1 from rc_backup_piece c where c.bs_key = a.bs_key and c.DEVICE_TYPE = 'SBT_TAPE')
order by bs_key;