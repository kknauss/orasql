set serveroutput on size 1000000;

DECLARE
  fhandle UTL_FILE.FILE_TYPE;
  line    VARCHAR2(32767);
BEGIN
  fhandle := UTL_FILE.FOPEN(location=>'GCC_FILES_DIR', filename=>'gcc_gl_summary_test.txt', open_mode=>'r');
  LOOP
    UTL_FILE.GET_LINE(fhandle, line);
    IF line IS NULL THEN
       dbms_output.put_line('Got empty line');
    ELSE
       dbms_output.put_line('Non empty line: '||line);
    END IF;
  END LOOP;
EXCEPTION
  WHEN no_data_found THEN
     dbms_output.put_line('No more data to read');
END;
/
