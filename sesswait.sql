column inst_id         format                  9 heading 'In|st';
column sid             format             999999; 
column seq#            format             999999 heading 'Seq#';
column event           format                a40 heading 'Wait Event';
column p1text          format                a32 heading 'Parameter 1';
column p1              format      9999999999999 heading 'Parameter|1|Value';
column p_1             format                a35 heading 'Parameter 1';
column p2text          format                a18 heading 'Parameter 2';
column p2              format      9999999999999 heading 'Parameter|2|Value';
column p_2             format                a35 heading 'Parameter 2';
column p3text          format                a18 heading 'Parameter 3';
column p3              format      9999999999999 heading 'Parameter|3|Value';
column p_3             format                a24 heading 'Parameter 3';
column wait_time       format             999999 heading 'Wait|Time(s)';
column seconds_in_wait format             999999 heading 'Seconds|In|Wait)';
column state           format                a18 heading 'State';
column wait_class      format                a12 heading 'Wait|Class';


--lect INST_ID, SID, SEQ#, EVENT, P1TEXT, P1, P2TEXT, P2, P3TEXT, P3, WAIT_TIME, SECONDS_IN_WAIT, STATE, WAIT_CLASS
SELECT INST_ID, SID, SEQ#, EVENT, P1TEXT||' '||P1 P_1, P2TEXT ||' '|| P2 P_2, P3TEXT ||' '|| P3 P_3, WAIT_TIME, SECONDS_IN_WAIT, STATE, WAIT_CLASS
FROM GV$SESSION_WAIT
WHERE INST_ID = &&INST_ID
AND SID = &&SID;
