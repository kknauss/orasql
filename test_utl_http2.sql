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

declare
	vResult CLOB;
	vURL VARCHAR2(1024);
begin
	select 'https://warloc.test.flagstar.com/warloc' into vURL from dual;

--	UTL_HTTP.set_wallet ('file:/wallet', 'flagstar123');
--	UTL_HTTP.set_wallet ('file:/u02/oradata/SMTR/wallet_DR', 'flagstar123');
        UTL_HTTP.set_wallet ('file:/wallet/WEB1', 'flagstar123');

	vResult := replace(UTL_HTTP.REQUEST(vURL),chr(10),' ');
	vResult := regexp_replace(vResult,'.*<title> ?(.+) ?</title>.*','\1',1,1,'i');
	dbms_output.put_line(vURL || ': ' || vResult);
end;
/
