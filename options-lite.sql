set linesize 132;

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
order by parameter;
