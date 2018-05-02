set serveroutput on size 1000000;

DECLARE
  p_location  VARCHAR2(30);
  p_filename  VARCHAR2(30);
  p_exists  BOOLEAN;
  p_file_length  NUMBER;
  p_blocksize  NUMBER;
BEGIN
  p_location := 'DW_FIN_DIR';
  p_filename := 'afs_detail_done.txt';
  UTL_FILE.FGETATTR(p_location, p_filename, p_exists, p_file_length, p_blocksize);
  IF p_exists THEN
      DBMS_OUTPUT.PUT_LINE(p_location||' - '||p_filename||' - '||p_file_length||' - '||p_blocksize);
DBMS_OUTPUT.PUT_LINE(p_filename||' is visiable!');
  ELSE
      DBMS_OUTPUT.PUT_LINE(p_location||' - '||p_filename||' - '||p_file_length||' - '||p_blocksize);
DBMS_OUTPUT.PUT_LINE(p_filename||' is not visible!');
  END IF;
END;
/
