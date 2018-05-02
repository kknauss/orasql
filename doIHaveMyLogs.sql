set verify off;
set heading off;
set feedback off;
set echo off;
set pagesize 44;
set linesize 132;

accept startDate prompt 'When did the archive/Flash backup begin [dd-mon-yyyy hh24:mi:ss]: '
accept endDate   prompt 'When did the archive/Flash backup end   [dd-mon-yyyy hh24:mi:ss]: '

alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';

column maxSCN format 999999999999999

select  'MAX SCN of last level 0 backup:      '||case when absfuzzy > maxchg THEN absfuzzy ELSE maxchg END
from (
	select max(absolute_fuzzy_change#) as absfuzzy, max( checkpoint_CHANGE# ) as maxchg
	from v$backup_datafile bd, v$backup_set bs
	where bs.set_count = bd.set_count
	and bs.incremental_level between 0 and 0 and bs.backup_type = 'D'
);

select  'MAX SCN of level 0 backup before archivelog/flash backup:      '||case when absfuzzy > maxchg THEN absfuzzy ELSE maxchg END
from (
	select max(absolute_fuzzy_change#) as absfuzzy, max( checkpoint_CHANGE# ) as maxchg
	from v$backup_datafile bd, v$backup_set bs
	where bs.set_count = bd.set_count
	and bs.incremental_level between 0 and 0 and bs.backup_type = 'D'
	and bs.completion_time <= to_date('&startDate','dd-mon-yyyy hh24:mi:ss')
);

select 'export NLS_DATE_FORMAT=''dd-mon-yyyy hh24:mi:ss'';' from dual;
select 'export NLS_LANG=american'                           from dual;
select 'list backup of archivelog all by file completed between ''&startDate'' and ''&endDate'';' from dual;
select 'list backup of archivelog sequence <last log seq# from previous command>;' from dual;

set heading on;
set feedback on;
set verify on;
set echo on;
