set pagesize 100
set linesize 132;

col diskgroup_name format a5
col name format a42
col value forma a32
col name format a22;
col value forma a12

select *
from v$asm_volume;
