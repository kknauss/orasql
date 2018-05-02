set linesize 180;
col type format a32;

SELECT dg.name, f.GROUP_NUMBER, f.FILE_NUMBER, f.BYTES/1024 FILE_KB, f.SPACE/1024 SIZE_KB, f.TYPE, f.STRIPED, f.CREATION_DATE, f.MODIFICATION_DATE, f.PERMISSIONS
FROM V$ASM_FILE f, v$asm_diskgroup dg
where f.group_number = dg.group_number
ORDER BY f.GROUP_NUMBER, f.FILE_NUMBER;
