--
-- controlfile parameters (cfp.sql)
--

select 
	case type
		when 'REDO THREAD'	then 'MAXINSTANCES'
		when 'REDO LOG'		then 'MAXLOGMEMBERS'
		when 'DATAFILE'		then 'MAXDATAFILES'
		when 'LOG HISTORY'	then 'MAXLOGHISTORY' end parameter,
	records_total value
from v$controlfile_record_section
where type in ('REDO THREAD','REDO LOG', 'DATAFILE', 'LOG HISTORY') ;
