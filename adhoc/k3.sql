set serveroutput on size 1000000;

DECLARE
  fhandle UTL_FILE.FILE_TYPE;
  line    VARCHAR2(32767);
BEGIN
  fhandle := UTL_FILE.FOPEN(location=>'UTL_DIR', filename=>'ktk3.txt', open_mode=>'w');

  UTL_FILE.putf(fhandle, 'I am so smart...\n');
  UTL_FILE.putf(fhandle, 'I am so smart...\n');
  UTL_FILE.putf(fhandle, 'S-M-R-T...\n');
  UTL_FILE.fclose(fhandle);
EXCEPTION
  WHEN utl_file.invalid_path THEN
     raise_application_error(-20000, 'ERROR: Invalid path  for file.');
END;
/
