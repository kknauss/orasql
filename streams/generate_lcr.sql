set serveroutput on size 1000000;
DECLARE
	v_lcr sys.lcr$_row_record;
BEGIN
	v_lcr := create_lcr( 'KNAUSS_DBA', 'KEITH', 'UPDATE' );

	-- Set some values
	v_lcr.set_value('new', 'F1', sys.anyData.convertVarchar2('124'));
	v_lcr.set_value('old', 'F1', sys.anyData.convertVarchar2('123'));

	-- Display Some Values
	DBMS_OUTPUT.PUT_LINE(	'Database: '		|| v_lcr.get_source_database_name()	|| 
				', Object Owner: '	|| v_lcr.get_object_owner()		|| 
				', Object Name: '	|| v_lcr.get_object_name()		||
				', Command: '		|| v_lcr.get_command_type() );

	DBMS_OUTPUT.PUT_LINE(	'New F1: '	|| sys.anyData.accessVarchar2(v_lcr.get_value('new', 'F1')) ||
				', Old F1: '	|| sys.anyData.accessVarchar2(v_lcr.get_value('old', 'F1')) );

	print_lcr(v_lcr);
END;
/
