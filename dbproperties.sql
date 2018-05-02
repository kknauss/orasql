col property_name format a32
col property_value format a50
col description format a115

select property_name, property_value, description
from database_properties
order by property_name;
