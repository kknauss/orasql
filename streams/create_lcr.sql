/*
 * For testing purposes...
 *
*/
CREATE OR REPLACE FUNCTION create_lcr( p_table_owner IN all_tables.owner%TYPE, p_table_name IN all_tables.table_name%TYPE, p_command IN VARCHAR2 ) RETURN sys.lcr$_row_record 
AS
	v_lcr		sys.lcr$_row_record;
	v_database	global_name.global_name%TYPE;
BEGIN
	-- verify the command type 
	IF p_command NOT IN ('INSERT', 'UPDATE', 'DELETE')
	THEN
		RETURN v_lcr;
	END IF;

	-- Get the database name
	-- This could be parameterized
	SELECT global_name INTO v_database FROM global_name;

	-- Construct the LCR
	v_lcr := sys.lcr$_row_record.construct( source_database_name => v_database, command_type => p_command, object_owner => p_table_owner, object_name => p_table_name );

	-- You can override the values in the constructor by calling these methods
	v_lcr.set_command_type(p_command);
	v_lcr.set_object_name(p_table_name);
	v_lcr.set_object_owner(p_table_owner);
	v_lcr.set_source_database_name(v_database);

	-- Loop through the columns and add new and old values
	FOR c1 IN ( SELECT column_name, data_type FROM all_tab_columns WHERE owner = p_table_owner AND table_name = p_table_name ORDER BY column_id )
	LOOP
		-- Create an anydata based on column data type
		-- You would expand this for all data types
		-- I'm going to keep this example fairly simple
		CASE c1.data_type
			WHEN 'VARCHAR2' THEN
				v_lcr.add_column('new', c1.column_name, sys.AnyData.convertVarChar2(TO_CHAR(NULL)));
				v_lcr.add_column('old', c1.column_name, sys.AnyData.convertVarChar2(TO_CHAR(NULL)));
			WHEN 'DATE' THEN
				v_lcr.add_column('new', c1.column_name, sys.AnyData.convertDate(TO_DATE(NULL)));
				v_lcr.add_column('old', c1.column_name, sys.AnyData.convertDate(TO_DATE(NULL)));
			WHEN 'NUMBER' THEN
				v_lcr.add_column('new', c1.column_name, sys.AnyData.convertNumber(TO_NUMBER(NULL)));
				v_lcr.add_column('old', c1.column_name, sys.AnyData.convertNumber(TO_NUMBER(NULL)));
		END CASE; 
	END LOOP;
RETURN v_lcr; END;
/
