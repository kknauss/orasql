set linesize 132;

--lect a.parameter || case nvl(b.onoff,-1) when 0 then ' (installed)' when -1 then ' (uknown)' else ' (active)' end as "Option"
--lect a.parameter || case when nvl(b.onoff,-1) > 0 then ' (active)' else ' (installed)'                        end as "Option"
select a.parameter || case when nvl(b.onoff,-1) > 0 then ' (active)' else ''                                    end as "Option"
from
(
	select 
		case parameter
			when 'Data Mining'               then 'ODM'
			when 'Oracle Label Security'     then 'OLS'
			when 'Oracle Database Vault'     then 'Vault'
			when 'Partitioning'              then 'Part'
			when 'Real Application Clusters' then 'RAC'
			when 'Real Application Testing'  then 'RAT'
			else parameter
		end parameter
	from v$option
	where parameter in
		(
			 'Data Mining'
			,'OLAP'
			,'Oracle Label Security'
			,'Oracle Database Vault'
			,'Partitioning'
			,'Real Application Clusters'
			,'Real Application Testing'
			,'Spatial'
		)
	and value = 'TRUE'
) a,
(
	select 'DUMMY' parameter,  1 onoff from dual
	union
	select 'ODM',      count(*)                    from dba_objects        where owner='DMSYS'   group by owner
	union
	select 'OLAP',     count(*)                    from dba_objects        where owner='OLAPSYS' group by owner
	union
	select 'OLS',      count(*)                    from dba_objects        where owner='LBACSYS' group by owner
	union
	select 'Part',     count(*) from dba_tables where partitioned = 'YES' and owner not in ('AUDSYS','SYSMAN','SYS','SYSTEM') group by owner
	union
	select 'RAC',      count(*)-1                  from gv$instance
	union
	select 'Spatial',  count(*)                    from dba_objects        where owner='MDSYS'   group by owner
) b
where a.parameter = b.parameter(+)
order by a.parameter;
