select owner, table_name, column_name 
from dba_tab_columns 
where data_type = 'SDO_GEOMETRY' 
and owner != 'MDSYS' 
order by 1,2,3;


prompt See Metalink note 179472.1 ...
