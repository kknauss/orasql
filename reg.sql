/*
 * How to Check if the Oracle JVM is Installed Correctly in the Database [ID 397770.1]
 * 
 * If Oracle JVM is installed, there will be a row in the registry similar to this:
 * COMP_NAME                                VERSION         STATUS 
 * ---------------------------------------- --------------- ----------- 
 * JServer JAVA Virtual Machine             10.2.0.3.0      VALID
 * 
*/
column comp_id       format a10 heading 'Component|ID';
column comp_name     format a36 heading 'Component Name';
column version       format a12 heading 'Version';
column status        format  a7 heading 'Status';
column modified      format a20 heading 'Modified Date';
column schema        format a12 heading 'Schema';
column procedure     format a36 heading 'Procedure';
column other_schemas format a62 heading 'Other Schemas';

column control       format  a4 heading 'Ctrl';
column namespace     format a12 heading 'Namespace';
column parent_id     format  a6 heading 'Parent|ID';

select comp_id, comp_name, version, status, modified, schema, procedure, other_schemas from dba_registry order by comp_id, comp_name;
