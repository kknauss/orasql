begin
sys.DBMS_LOGMNR.ADD_LOGFILE( 
   LogFileName     =>  '/archive/varad.20081209/ARC53615794317320.0001'
  -- Options         => sys.DBMS_LOGMNR.new
 );
 /*
 sys.DBMS_LOGMNR.ADD_LOGFILE( 
   LogFileName     =>  '/u01/app/oracle/admin/DBRAV/archive/ARC10583598998130.0001'
  -- Options         => sys.DBMS_LOGMNR.new
 );
  sys.DBMS_LOGMNR.ADD_LOGFILE( 
   LogFileName     =>  '/u01/app/oracle/admin/DBRAV/archive/ARC10584598998130.0001'
  -- Options         => sys.DBMS_LOGMNR.new
 );
  sys.DBMS_LOGMNR.ADD_LOGFILE( 
   LogFileName     =>  '/u01/app/oracle/admin/DBRAV/archive/ARC10585598998130.0001'
  -- Options         => sys.DBMS_LOGMNR.new
 );
 */
 end;
 
 set role dba;

select * from v$loghist;

select * from gv$parameter;

select distinct name from dba_source where name like '%LOGMN%';

begin
sys.DBMS_LOGMNR.START_LOGMNR (options=> sys.DBMS_LOGMNR.COMMITTED_DATA_ONLY );
sys.DBMS_LOGMNR.START_LOGMNR (options=> sys.DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG );
end;

exec sys.dbms_logmnr.start_logmnr(dictfilename => '/archive/CDC/brav_dict.txt');
select * from v$archived_log;

select * from user_ts_quotas;

select * from v$logmnr_logs;
select * from dba_views where view_name like '%V%$%LOGMN%';

create synonym dbms_logmnr for sys.dbms_logmnr;

select * from v$ARCHIVED_LOG order by first_time desc;

exec sys.DBMS_LOGMNR.END_LOGMNR;

select * from dba_views where view_name like '%V%$%LOG%';
grant select on trans_all to public;
alter table trans_all add sql varchar2(4000);

insert into  trans_all  
select DATA_OBJ#,OPERATION_code,operation,  null,log_id,sql_redo,seg_owner,seg_name
from v$logmnr_contents 
where operation_code  IN (1,2,3) and seg_type=2 
--GROUP BY DATA_OBJ#,OPERATION_code,operation,log_id;
;


select * from v$logmnr_contents;

select b.table_name,operation,count(*) 
from v$logmnr_contents b
--, mortrac_dw_replicated_table@ddw b
where 1=1
--a.seg_name=b.table_name 
group by b.table_name,operation
;
/*
UNION 
SELECT 'DB','DCLS' ,COUNT(*)
FROM V$LOGMNR_CONTENTS
WHERE  operation in ('COMMIT','ROLLBACK');
*/

select count(*),TABLE_NAME,session_info
 from v$logmnr_contents where seg_name in ('MORTGAGE','MTG_MP','BORR_ANSWER')
 GROUP BY TABLE_NAME,SESSION_INFO;

select seg_name,OPERATION,count(*) from v$logmnr_contents 
where TIMESTAMP BETWEEN TO_DATE('03/10/2008 1148','MM/DD/YYYY HH24MI') AND TO_DATE('03/10/2008 1150','MM/DD/YYYY HH24MI') 
group by seg_name,OPERATION 
order by 3 desc;

select * from v$logmnR_contents 
where TIMESTAMP BETWEEN TO_DATE('03/10/2008 1148','MM/DD/YYYY HH24MI') AND TO_DATE('03/10/2008 1150','MM/DD/YYYY HH24MI') ;

select DATA_OBJ#,OPERATION_code,operation,  count(*) cnt
from v$logmnr_contents 
where data_obj# IN (8029,8136,8105) GROUP BY DATA_OBJ#,OPERATION_code,operation;

select * from dba_objects where object_name in ('MTG_LP' ) AND OWNER='BRAVURA' and object_type='TABLE';


select b.object_name,operation_code,substr(sql_text,100) sqlt,count(*)
from trans_all a, dba_objects@sbrav b
where a.DATA_OBJ#=b.OBJECT_ID and object_type='TABLE' and owner='BRAVURA' 
group by b.object_name,operation_code,substr(sql_text,100) 
;

alter table trans_all add (object_owner varchar2(35), object_name varchar2(35));

select * from trans_all;

alter session set global_names=false;

alter table trans_all rename column sql to sql_text;

select log_id,scn,timestamp, row_id, dbms_logmnr.COLUMN_PRESENT( redo_value ,'BRAVURA.NTG_LOCK_HISTORY.LOCK_STATUS') LCK,SQL_REDO
from v$logmnr_contents 
where data_obj#=8105 and operation_code in (1,2,3);

select * from v$parameter;

select * from gv$logmnr_logfile;


select min(timestamp), max(timestamp) from v$logmnr_contents;


select seg_name,sql_redo from v$logmnr_contents  WHERE SEG_OWNER='BRAVURA';
--where seg_name='MTG_LOCK_HIST';

select * from dba_hist_wr_control;
dbms_logmnr_d