set serveroutput on size 1000000;

declare
	vResult CLOB;
	vURL VARCHAR2(1024);
begin
	select 'http://www.oracle.com' into vURL from dual;

	vResult := vURL || UTL_TCP.CRLF;
	dbms_output.put_line(vResult);
end;
/
