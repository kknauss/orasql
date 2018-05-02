column inst_id      format    9    heading 'In|st';
column name                  format a33 heading 'Name';
column display_value         format a64 heading 'Value';
column type                  format  a6 heading 'Type';
column isdefault             format  a4 heading 'De-|flt?';
column isses_modifiable      format  a5 heading 'Alter|Sess-|ion?';
column issys_modifiable      format  a9 heading 'Alter|System?';
column isinstance_modifiable format  a4 heading 'Inst|Can|Be|Diff|?';
column ismodified            format a10 heading 'Modified?';
column isadjusted            format  a6 heading 'Oracle|Adjus-|ted?';
column isdeprecated          format  a6 heading 'Depre-|cated|?';
column update_comment        format a14 heading 'Update Comment';
column description           format a75 heading 'Description';

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept param prompt 'Parameter Name........ '
SET TERMOUT off;
	COLUMN param NEW_VALUE _param ;
	select case when '&&param' IS NULL then 'ALL' else lower('&&param') end as param from dual;
SET TERMOUT on;

select	inst_id,
	name, 
	display_value,
	case isdefault             when 'TRUE'  then 'Yes' when 'FALSE' then 'No' else isdefault             end isdefault, 
	case isses_modifiable      when 'TRUE'  then 'Yes' when 'FALSE' then 'No' else isses_modifiable      end isses_modifiable, 
	issys_modifiable,
	case isinstance_modifiable when 'TRUE'  then 'Yes' when 'FALSE' then 'No' else isinstance_modifiable end isinstance_modifiable, 
	case ismodified            when 'FALSE' then 'No'                         else ismodified            end ismodified, 
	case isadjusted            when 'TRUE'  then 'Yes' when 'FALSE' then 'No' else isadjusted            end isadjusted, 
	case isdeprecated          when 'TRUE'  then 'Yes' when 'FALSE' then 'No' else isdeprecated          end isdeprecated, 
--	case type                  when 1 then 'bool' when 2 then 'string' when 3 then 'int' when 4 then 'pfile' when 5 then 'RESRVD' when 6 then 'bigint' else 'UNK' end type,
--	update_comment,
	description
from gv$parameter
where ( name like '%&&_param%' OR  'ALL' = '&&_param' )
order by name, inst_id;

UNDEF param
