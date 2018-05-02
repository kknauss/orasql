--CONNECT STREAMS_ADMIN;

/* ************************************************************************** *
 *  Subject: Procedure to Print LCRs                                          *
 *  Doc ID: 405541.1                                                          *
 *                                                                            *
 *  PURPOSE                                                                   *
 *  -------                                                                   *
 *  Creating a Procedure to get the output of print_lcr procedure.            *
 *  Creating a Procedure That Prints a Specified LCR                          *
 *  Creating a Procedure That Prints All the LCRs in the Error Queue          *
 *  Creating a Procedure that Prints All the Error LCRs for a Transaction     *
 *                                                                            *
 *  Applicable for Oracle version 9i to 10g                                   *
 * ************************************************************************** */


/* 
 * Creating a Procedure to get the output of print_lcr procedure.
 * ------------------------------------------------------------------------
 * To print_any procedure to get the output of print_lcr procedure.
 * 
 * The following procedure prints the value in a specified ANYDATA object for
 * some selected datatypes. You can add more datatypes to this procedure if you wish.
*/ 
CREATE OR REPLACE PROCEDURE print_any(data IN ANYDATA)
IS
	tn  VARCHAR2(61);
	str VARCHAR2(4000);
	chr VARCHAR2(1000);
	num NUMBER;
	dat DATE;
	rw  RAW(4000);
	res NUMBER;
BEGIN
	IF data IS NULL
	THEN
		DBMS_OUTPUT.PUT_LINE('NULL value');
		RETURN;
	END IF;

	tn := data.GETTYPENAME();

	IF tn = 'SYS.VARCHAR2'
	THEN
		res := data.GETVARCHAR2(str);
		DBMS_OUTPUT.PUT_LINE(SUBSTR(str,0,253));
	ELSIF tn = 'SYS.CHAR'
	then
		res := data.GETCHAR(chr);
		DBMS_OUTPUT.PUT_LINE(SUBSTR(chr,0,253));
	ELSIF tn = 'SYS.VARCHAR'
	THEN
		res := data.GETVARCHAR(chr);
		DBMS_OUTPUT.PUT_LINE(chr);
	ELSIF tn = 'SYS.NUMBER'
	THEN
		res := data.GETNUMBER(num);
		DBMS_OUTPUT.PUT_LINE(num);
	ELSIF tn = 'SYS.DATE'
	THEN
		res := data.GETDATE(dat);
		DBMS_OUTPUT.PUT_LINE(dat);
	ELSIF tn = 'SYS.RAW'
	THEN
		-- res := data.GETRAW(rw);
		-- DBMS_OUTPUT.PUT_LINE(SUBSTR(DBMS_LOB.SUBSTR(rw),0,253));
		DBMS_OUTPUT.PUT_LINE('BLOB Value');
	ELSIF tn = 'SYS.BLOB'
	THEN
		DBMS_OUTPUT.PUT_LINE('BLOB Found');
	ELSE
		DBMS_OUTPUT.PUT_LINE('typename is ' || tn);
	END IF;
END print_any;
/


/*
 * Creating a Procedure That Prints a Specified LCR
*/
CREATE OR REPLACE PROCEDURE print_lcr(lcr IN SYS.ANYDATA)
IS
	typenm VARCHAR2(61);
	ddllcr SYS.LCR$_DDL_RECORD;
	proclcr SYS.LCR$_PROCEDURE_RECORD;
	rowlcr SYS.LCR$_ROW_RECORD;
	res NUMBER;
	newlist SYS.LCR$_ROW_LIST;
	oldlist SYS.LCR$_ROW_LIST;
	ddl_text CLOB;
BEGIN
	typenm := lcr.GETTYPENAME();
	DBMS_OUTPUT.PUT_LINE('type name: ' || typenm);

	IF (typenm = 'SYS.LCR$_DDL_RECORD')
	THEN
		res := lcr.GETOBJECT(ddllcr);
		DBMS_OUTPUT.PUT_LINE('source database: ' ||
		ddllcr.GET_SOURCE_DATABASE_NAME);
		DBMS_OUTPUT.PUT_LINE('owner: ' || ddllcr.GET_OBJECT_OWNER);
		DBMS_OUTPUT.PUT_LINE('object: ' || ddllcr.GET_OBJECT_NAME);
		DBMS_OUTPUT.PUT_LINE('is tag null: ' || ddllcr.IS_NULL_TAG);
		DBMS_LOB.CREATETEMPORARY(ddl_text, TRUE);
		ddllcr.GET_DDL_TEXT(ddl_text);
		DBMS_OUTPUT.PUT_LINE('ddl: ' || ddl_text);
		DBMS_LOB.FREETEMPORARY(ddl_text);
	ELSIF (typenm = 'SYS.LCR$_ROW_RECORD')
	THEN
		res := lcr.GETOBJECT(rowlcr);
		DBMS_OUTPUT.PUT_LINE('source database: ' ||
		rowlcr.GET_SOURCE_DATABASE_NAME);
		DBMS_OUTPUT.PUT_LINE('owner: ' || rowlcr.GET_OBJECT_OWNER);
		DBMS_OUTPUT.PUT_LINE('object: ' || rowlcr.GET_OBJECT_NAME);
		DBMS_OUTPUT.PUT_LINE('is tag null: ' || rowlcr.IS_NULL_TAG);
		DBMS_OUTPUT.PUT_LINE('command_type: ' || rowlcr.GET_COMMAND_TYPE);
		oldlist := rowlcr.GET_VALUES('OLD');

		FOR i IN 1..oldlist.COUNT
		LOOP
			if oldlist(i) is not null
			then
				DBMS_OUTPUT.PUT_LINE('old(' || i || '): ' || oldlist(i).column_name);
				print_any(oldlist(i).data);
			END IF;
		END LOOP;

		newlist := rowlcr.GET_VALUES('NEW');

		FOR i in 1..newlist.count
		LOOP
			IF newlist(i) IS NOT NULL
			THEN
				DBMS_OUTPUT.PUT_LINE('new(' || i || '): ' || newlist(i).column_name);
				print_any(newlist(i).data);
			END IF;
		END LOOP;
	ELSE
		DBMS_OUTPUT.PUT_LINE('Non-LCR Message with type ' || typenm);
	END IF;
END print_lcr;
/


/*
 * Creating a Procedure That Prints All the LCRs in the Error Queue
 * -------------------------------------------------------------------
 * The following procedure prints all of the LCRs in the error queue. It calls the
 * print_lcr procedure created in "Creating a Procedure That Prints a Specified
 * LCR"
 *
 * To run this procedure:
 *
 * SET SERVEROUTPUT ON SIZE 1000000;
 * EXEC print_errors;
*/
CREATE OR REPLACE PROCEDURE print_errors
IS
	i	NUMBER;
	txnid	VARCHAR2(30);
	source	VARCHAR2(128);
	msgcnt	NUMBER;
	errnum	NUMBER := 0;
	errno	NUMBER;
	errmsg	VARCHAR2(128);
	lcr	SYS.AnyData;
	r	NUMBER;

	CURSOR c IS	SELECT LOCAL_TRANSACTION_ID, SOURCE_DATABASE, MESSAGE_COUNT, ERROR_NUMBER, ERROR_MESSAGE
			FROM DBA_APPLY_ERROR
			ORDER BY SOURCE_DATABASE, SOURCE_COMMIT_SCN;
BEGIN
	FOR r IN c
	LOOP
		errnum := errnum + 1;
		msgcnt := r.MESSAGE_COUNT;
		txnid := r.LOCAL_TRANSACTION_ID;
		source := r.SOURCE_DATABASE;
		errmsg := r.ERROR_MESSAGE;
		errno := r.ERROR_NUMBER;

		DBMS_OUTPUT.PUT_LINE('*************************************************');
		DBMS_OUTPUT.PUT_LINE('----- ERROR #' || errnum);
		DBMS_OUTPUT.PUT_LINE('----- Local Transaction ID: ' || txnid);
		DBMS_OUTPUT.PUT_LINE('----- Source Database: ' || source);
		DBMS_OUTPUT.PUT_LINE('----Error Number: '||errno);
		DBMS_OUTPUT.PUT_LINE('----Message Text: '||errmsg);

		FOR i IN 1..msgcnt
		LOOP
			DBMS_OUTPUT.PUT_LINE('--message: ' || i);
			lcr := DBMS_APPLY_ADM.GET_ERROR_MESSAGE(i, txnid);
			print_lcr(lcr);
		END LOOP;
	END LOOP;
END print_errors;
/


/*
 * Creating a Procedure that Prints All the Error LCRs for a Transaction
 * --------------------------------------------------------------------
 * The following procedure prints all the LCRs in the error queue for a particular
 * transaction. It calls the print_lcr procedure created in "Creating a Procedure That
 * Prints a Specified LCR"
 *
 * To run this procedure, pass it the local transaction:
 *
 * SET SERVEROUTPUT ON SIZE 1000000;
 * EXEC print_transaction('9.33.65368');
*/
CREATE OR REPLACE PROCEDURE print_transaction(ltxnid IN VARCHAR2)
IS
	i	NUMBER;
	txnid	VARCHAR2(30);
	source	VARCHAR2(128);
	msgcnt	NUMBER;
	errno	NUMBER;
	errmsg	VARCHAR2(128);
	lcr	SYS.ANYDATA;
BEGIN
	SELECT LOCAL_TRANSACTION_ID, SOURCE_DATABASE, MESSAGE_COUNT, ERROR_NUMBER, ERROR_MESSAGE
	INTO txnid, source, msgcnt, errno, errmsg
	FROM DBA_APPLY_ERROR
	WHERE LOCAL_TRANSACTION_ID = ltxnid;

	DBMS_OUTPUT.PUT_LINE('----- Local Transaction ID: ' || txnid);
	DBMS_OUTPUT.PUT_LINE('----- Source Database: ' || source);
	DBMS_OUTPUT.PUT_LINE('----Error Number: '||errno);
	DBMS_OUTPUT.PUT_LINE('----Message Text: '||errmsg);

	FOR i IN 1..msgcnt
	LOOP
		DBMS_OUTPUT.PUT_LINE('--message: ' || i);
		lcr := DBMS_APPLY_ADM.GET_ERROR_MESSAGE(i, txnid); -- gets the LCR
		print_lcr(lcr);
	END LOOP;
END print_transaction;
/
