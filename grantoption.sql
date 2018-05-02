undef grantto
undef own
undef obj


select 'grant '|| case referenced_type
                     when 'PACKAGE' THEN 'EXECUTE'
                     when 'PROCEDURE' THEN 'EXECUTE'
                     when 'FUNCTION' THEN 'EXECUTE'
                     else 'SELECT'
END ||' on /*'||referenced_type||'*/ '||referenced_owner||'.'||referenced_name||' to &&grantto with grant option;'
from dba_dependencies
where  owner = upper('&&own')
and name = upper('&&obj')
and referenced_type != 'NON-EXISTENT';
