/*
 * http://download.oracle.com/docs/cd/B19306_01/em.102/b25986/rac_database.htm#sthref465
 */
SELECT blocking_sid, num_blocked
FROM
(
    SELECT blocking_sid, SUM(num_blocked) num_blocked
    FROM
    (
        SELECT l.id1, l.id2, MAX(DECODE(l.block, 1, i.instance_name||'-'||l.sid, 2, i.instance_name||'-'||l.sid, 0 )) blocking_sid, SUM(DECODE(l.request, 0, 0, 1 )) num_blocked 
        FROM gv$lock l, gv$instance i
        WHERE ( l.block!= 0 OR l.request > 0 )
        AND l.inst_id = i.inst_id
        GROUP BY l.id1, l.id2
    )
    GROUP BY blocking_sid 
    ORDER BY num_blocked DESC
)
WHERE num_blocked != 0;


select * from gv$lock where block =1  order by ctime;