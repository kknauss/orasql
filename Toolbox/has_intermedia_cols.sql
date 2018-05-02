--Run as user SYS
--[NOTE:229112.1] 
--9i 
-- -> IF you want ALL currently supported ORD% OBJECT TYPES, USE:
-- ORDDOC','ORDIMAGESIGNATURE','ORDIMAGE','ORDAUDIO','ORDVIDEO','ORDSOURCE
-- -> IF you want THE currently supported AS well AS THE deprecated OBJECT TYPES, USE:
-- ORDDOC','ORDIMAGESIGNATURE','ORDIMAGE','ORDAUDIO','ORDVIDEO','ORDSOURCE,'ORDIMGB','ORDIMGF','ORDVIR
--8i
-- -> IF you want ALL currently supported ORD% OBJECT TYPES, USE:
-- ORDIMAGE','ORDAUDIO','ORDVIDEO','ORDSOURCE
-- -> IF you want THE currently supported AS well AS THE deprecated OBJECT TYPES, USE:
-- ORDIMAGE','ORDAUDIO','ORDVIDEO','ORDSOURCE','ORDIMGB','ORDIMGF
COLUMN owner       format a20
COLUMN object_name format a30
COLUMN object_type format a10
COLUMN data_type   format a15

SET PAGES 999 
SET LINES 80
SET FEEDBACK OFF
SET SERVEROUT ON 
SET PAUSE OFF 
SET VERIFY OFF 

ACCEPT ord_object_type_list  PROMPT 'Enter the object types to be checked: '


SELECT a.owner, a.object_name, a.object_type,d.data_type
FROM   DBA_OBJECTS a , DBA_TAB_COLUMNS d
WHERE a.object_id IN
 (SELECT b.d_obj#  FROM   dependency$ b
  WHERE b.P_obj#
  IN (
     SELECT c.object_id FROM DBA_OBJECTS c
     WHERE c.owner = 'ORDSYS'
     AND c.object_type = 'TYPE'
     AND c.object_name IN ('&ord_object_type_list')))
AND  a.object_type = 'TABLE'
AND  d.owner = a.owner
AND  d.table_name = a.object_name
AND  d.data_type IN  ('&ord_object_type_list');
SET feedback ON
SET VERIFY ON
