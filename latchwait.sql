SELECT n.name, SUM(w.p3) Sleeps
  FROM V$SESSION_WAIT w, V$LATCHNAME n
 WHERE w.event = 'latch free'
   AND w.p2 = n.latch#
 GROUP BY n.name;
