SET TIMING ON;
SET SERVEROUTPUT ON SIZE 1000000 FORMAT WRAPPED;
SET LINESIZE 132;

DECLARE
     L_COLSEP  VARCHAR2(2) := '  ';
     NO  NUMBER := 0;
     YES NUMBER := 1;
     L_PRINTHEADING NUMBER;
     L_PRINTDETAIL  NUMBER;
     L_PRINTDETAILHDR  NUMBER;
     L_TBSPACE DBA_TABLESPACES.TABLESPACE_NAME%TYPE;
     L_EXTMGT  DBA_TABLESPACES.EXTENT_MANAGEMENT%TYPE;
     L_DEFNEXT NUMBER;
     L_MAXFREE NUMBER;
     L_FILENME DBA_DATA_FILES.FILE_NAME%TYPE;
     L_FILESZE NUMBER;
     L_FILEMAX NUMBER;
     L_AUTOEXT NUMBER;
     L_AUTOCNT NUMBER;
     L_SEGOWNR DBA_SEGMENTS.OWNER%TYPE;
     L_SEGNAME DBA_SEGMENTS.SEGMENT_NAME%TYPE;
     L_SEGTYPE DBA_SEGMENTS.SEGMENT_TYPE%TYPE;
     L_SEGSIZE NUMBER;
     L_SEGNEXT NUMBER;
     L_PCTINCR NUMBER;
     CURSOR C_TBSPCE
          IS SELECT TABLESPACE_NAME, EXTENT_MANAGEMENT, NVL2(NEXT_EXTENT,NEXT_EXTENT,INITIAL_EXTENT) FROM DBA_TABLESPACES WHERE CONTENTS NOT IN ('TEMPORARY','UNDO');
     CURSOR C_FREESP (TBS VARCHAR2)
          IS SELECT MAX(BYTES) FROM DBA_FREE_SPACE WHERE TABLESPACE_NAME = TBS;
     CURSOR C_SEGMNT (TBS VARCHAR2)
          IS SELECT OWNER, SEGMENT_NAME, SEGMENT_TYPE, BYTES, NEXT_EXTENT, PCT_INCREASE FROM DBA_SEGMENTS WHERE TABLESPACE_NAME = TBS ORDER BY NEXT_EXTENT DESC;
     CURSOR C_AUTOEX (TBS VARCHAR2)
          IS SELECT FILE_NAME, BYTES, NVL(MAXBYTES,0) FROM DBA_DATA_FILES WHERE AUTOEXTENSIBLE = 'YES' AND TABLESPACE_NAME = TBS GROUP BY FILE_NAME, BYTES, MAXBYTES ORDER BY FILE_NAME;
BEGIN
     OPEN C_TBSPCE;
     LOOP
          FETCH C_TBSPCE INTO L_TBSPACE, L_EXTMGT, L_DEFNEXT;
          EXIT WHEN C_TBSPCE%NOTFOUND;

          L_PRINTHEADING := YES;
          L_PRINTDETAIL  :=  NO;

          OPEN C_FREESP (L_TBSPACE);
          FETCH C_FREESP INTO L_MAXFREE;
          CLOSE C_FREESP;

          IF (L_MAXFREE IS NULL) THEN
               L_MAXFREE := 0;
          END IF;

          OPEN C_SEGMNT (L_TBSPACE);
          LOOP
               FETCH C_SEGMNT INTO L_SEGOWNR,L_SEGNAME,L_SEGTYPE,L_SEGSIZE,L_SEGNEXT,L_PCTINCR;
               EXIT WHEN C_SEGMNT%NOTFOUND;
          /*
           * According to Doc 1025288.6 we need to account for PCTINCREASE; however, this
           * appears to be included in the next_extent when querying dba_segments, so I
           * am only calculating if we are forced to use default values (i.e. next_extent
           * not retrievable from dba_segments.
          */
               IF (L_SEGNEXT IS NULL) THEN
                    L_SEGNEXT := L_DEFNEXT;

                    IF (L_EXTMGT = 'DICTIONARY') THEN
                         L_SEGNEXT := L_SEGNEXT * (1 + (L_PCTINCR/100));
                    END IF;
               END IF;

               IF (L_SEGNEXT > L_MAXFREE) THEN
                    L_PRINTDETAIL := YES;

                    IF (L_PRINTHEADING = YES) THEN
                         DBMS_OUTPUT.PUT_LINE(' ');
                         DBMS_OUTPUT.PUT_LINE('                                Extent      Largest Free');
                         DBMS_OUTPUT.PUT_LINE('Tablespace Name                 Management     Extent MB');
                         DBMS_OUTPUT.PUT_LINE('------------------------------  ----------  ------------');

                         DBMS_OUTPUT.PUT_LINE(
                                   RPAD(          L_TBSPACE                           , 30)  || L_COLSEP ||
                                   RPAD(          L_EXTMGT                            , 10)  || L_COLSEP ||
                                   LPAD( TO_CHAR( L_MAXFREE/(1024*1024),'99999999.99'), 12)
                              );

                         DBMS_OUTPUT.PUT_LINE(' ');
                         DBMS_OUTPUT.PUT_LINE('     Objects with next extent larger than currently available in '||L_TBSPACE);
                         DBMS_OUTPUT.PUT_LINE('     Owner                 Object Name                                    Object Type     Curr MB    Next MB');
                         DBMS_OUTPUT.PUT_LINE('     --------------------  ---------------------------------------------  ------------  ---------  ---------');
                         L_PRINTHEADING := NO;
                    END IF;

                    DBMS_OUTPUT.PUT_LINE(
                                             RPAD(          ' '                              ,  3)  || L_COLSEP ||
                                             RPAD(          L_SEGOWNR                        , 20)  || L_COLSEP ||
                                             RPAD(          L_SEGNAME                        , 45)  || L_COLSEP ||
                                             RPAD(          L_SEGTYPE                        , 12)  || L_COLSEP ||
                                             LPAD( TO_CHAR( L_SEGSIZE/(1024*1024),'99999.99'),  9)  || L_COLSEP ||
                                             LPAD( TO_CHAR( L_SEGNEXT/(1024*1024),'99999.99'),  9)
                                        );
               END IF;
          END LOOP;
          CLOSE C_SEGMNT;

          IF (L_PRINTDETAIL = YES)
          THEN
               L_PRINTDETAILHDR := YES;
               L_AUTOEXT := 0;
               L_AUTOCNT := 0;

               OPEN C_AUTOEX (L_TBSPACE);
               LOOP
                    FETCH C_AUTOEX INTO L_FILENME, L_FILESZE, L_FILEMAX;
                    EXIT WHEN C_AUTOEX%NOTFOUND;

                    IF (L_PRINTDETAILHDR = YES) THEN
                         DBMS_OUTPUT.PUT_LINE(' ');
                         DBMS_OUTPUT.PUT_LINE('     Autoextensible datafiles for tablespace '||L_TBSPACE);
                         DBMS_OUTPUT.PUT_LINE('     Filename                                                                  Curr MB     Max MB    Diff MB');
                         DBMS_OUTPUT.PUT_LINE('     ----------------------------------------------------------------------  ---------  ---------  ---------');
                         L_PRINTDETAILHDR := NO;
                    END IF;

                    L_AUTOEXT := (L_FILEMAX - L_FILESZE);
                    L_AUTOCNT := L_AUTOCNT + 1;
                    DBMS_OUTPUT.PUT_LINE(
                                             RPAD(          ' '                               ,  3)  || L_COLSEP ||
                                             RPAD(          L_FILENME                         , 70)  || L_COLSEP ||
                                             LPAD( TO_CHAR( L_FILESZE/(1024*1024),'999999.99'),  9)  || L_COLSEP ||
                                             LPAD( TO_CHAR( L_FILEMAX/(1024*1024),'999999.99'),  9)  || L_COLSEP ||
                                             LPAD( TO_CHAR( L_AUTOEXT/(1024*1024),'999999.99'),  9)
                                        );
               END LOOP;
               CLOSE C_AUTOEX;

               IF (L_AUTOCNT = 0) THEN
                    DBMS_OUTPUT.PUT_LINE(' ');
                    DBMS_OUTPUT.PUT_LINE('     No autoextensible datafiles for tablespace '||L_TBSPACE);
               END IF;
          END IF;
     END LOOP;
     CLOSE C_TBSPCE;
END;
/
