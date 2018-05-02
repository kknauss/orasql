column inst_id_loc	format a4	heading 'Inst|ID' JUSTIFY RIGHT;
column instance_name	format a13	heading 'Instance Name';
column host_name	format a12	heading 'Hostname';
column status		format a8	heading 'Status';
column instance_number			heading 'Instance|Number';
column thread#				heading 'Thread#';
column startup_time	format a19	heading 'Startup Time';
column uptime           format a11      heading '     Uptime|  hhh:mm:ss';

select	lpad(case when (select instance_number from v$instance) = inst_id then '*' else ' ' end || trim(to_char(inst_id,'09')),04) inst_id_loc,
	instance_name,
	host_name,
	status,
	instance_number,
	thread#,
	to_char(startup_time,'mm/dd/yyyy hh24:mi:ss') startup_time,
	     to_char(floor(    ((sysdate-startup_time)*24*60*60) /(60*60))            ,'0999')  ||':'||
	trim(to_char(floor(mod(((sysdate-startup_time)*24*60*60) ,(60*60))/60)          ,'09')) ||':'||
	trim(to_char(      mod(((sysdate-startup_time)*24*60*60) ,(60))                 ,'09'))
uptime
from gv$instance
order by inst_id;
