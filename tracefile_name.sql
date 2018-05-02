/*
 * alter session set events '10046 trace name context forever, level N';
 *
 * Level	Implied Bitmap	Function
 *     0	          0000	Emit no statistics
 *     1	          0001	Emit ***, APPNAME, PARSING IN CUROR, PARSE ERROR, EXEC, FECTH, UNMAP, SORT UNMAP, ERROR, STAT, and XCTEND lines
 *     2	          0011	Apparently identical to level-1
 *     4	          0101	Emit BINDS sections in addition to level-1 lines
 *     8	          1001	Emit WAIT lines in addition to level-1 lines
 *    12	          1101	Emit level-1, level-4, and level-8 lines
 *
 */

select r.value ||'/'|| i.instance_name ||'_ora_'|| p.spid ||'.trc' as "Trace file name"
from v$process p, v$session s, v$instance i, (select value from v$parameter where name = 'user_dump_dest') r
where s.sid = (select sid from v$mystat where rownum = 1)
and s.paddr = p.addr;
