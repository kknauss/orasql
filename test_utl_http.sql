/*
SELECT UTL_HTTP.request (
          'https://fstroysecrpt01/workspace/callevent.jsp?ename=PING',
           NULL,
          'file:/u02/oradata/DW/wallet',
          'flagstar1')
  FROM DUAL;
*/

set serveroutput on size 1000000;

declare
	vResult CLOB;
	vURL VARCHAR2(1024);
begin
	select 'http://www.oracle.com' into vURL from dual;

	vResult := replace(UTL_HTTP.REQUEST(vURL),chr(10),' ');
	vResult := regexp_replace(vResult,'.*<title> ?(.+) ?</title>.*','\1',1,1,'i');
	dbms_output.put_line(vResult);
end;
/

/*
DECLARE
	vResult CLOB;
	vURL VARCHAR2(1024);
BEGIN
--	select 'http://www.flagstar.com' into vURL from dual;
	select 'https://m4web.staging.flagstar.com/webservice/AddressInterface' into vURL from dual;

	UTL_HTTP.set_wallet ('file:/wallet', 'flagstar123');
--	UTL_HTTP.set_wallet ('file:/u02/oradata/SMTR/wallet_DR', 'flagstar123');
	vResult := replace(UTL_HTTP.REQUEST(vURL),chr(10),' ');
	vResult := regexp_replace(vResult,'.*<title> ?(.+) ?</title>.*','\1',1,1,'i');
	dbms_output.put_line(vURL || ': ' || vResult);
END;
*/

DECLARE
	vResult CLOB;
	vURL VARCHAR2(1024);
BEGIN
	select 'https://m4web.staging.flagstar.com/webservice/AddressInterface' into vURL from dual;
	UTL_HTTP.set_wallet ('file:/wallet', 'flagstar123');
	vResult := replace(UTL_HTTP.REQUEST(vURL),chr(10),' ');
	vResult := regexp_replace(vResult,'.*<title> ?(.+) ?</title>.*','\1',1,1,'i');
	dbms_output.put_line(vURL || ': ' || vResult);
END;
/


DECLARE
	vResult CLOB;
	vURL VARCHAR2(1024);
BEGIN
	select 'https://wholesale.dev.flagstar.com/incomeverification/IncomeVerificationServlet' into vURL from dual;
	UTL_HTTP.set_wallet ('file:/wallet', 'flagstar123');
	vResult := replace(UTL_HTTP.REQUEST(vURL),chr(10),' ');
	vResult := regexp_replace(vResult,'.*<title> ?(.+) ?</title>.*','\1',1,1,'i');
	dbms_output.put_line(vURL || ': ' || vResult);
END;
/
