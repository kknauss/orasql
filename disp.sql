SELECT network protocol,
(SUM (busy) / (SUM (busy) + SUM (idle))) * 100 busy
FROM v$dispatcher
GROUP BY network; 
