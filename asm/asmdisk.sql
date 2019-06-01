set linesize 255;
set pagesize 55;
col name  format a14;
col label format a12;
col path  format a32;
col failgroup  format a14;

SELECT GROUP_NUMBER, DISK_NUMBER, MOUNT_STATUS, HEADER_STATUS, MODE_STATUS, STATE, OS_MB, TOTAL_MB, FREE_MB, NAME, FAILGROUP, LABEL, PATH, to_char(MOUNT_DATE,'mm/dd/yyyy hh24:mi:ss') MOUNT_DATE, VOTING_FILE
FROM V$ASM_DISK
ORDER BY GROUP_NUMBER, DISK_NUMBER;
