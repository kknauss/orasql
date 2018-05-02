set pagesize 100
set linesize 132;

col diskgroup_name format a5
col name format a42
col value forma a32
col name format a22;
col value forma a12

select a.group_number, d.name diskgroup_name, a.name, a.value, a.read_only, a.system_created 
from v$asm_attribute a, v$asm_diskgroup d
where a.group_number = d.group_number
and a.name in ('compatible.asm','compatible.advm', 'compatible.rdbms');
