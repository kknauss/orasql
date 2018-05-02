column owner     format a18 heading 'Owner';
column db_link   format a46 heading 'DB Link';
column username  format a18 heading 'User Name';
column host      format a32 heading 'Host';
column created              heading 'Created';

UNDEF lowner
UNDEF lname
UNDEF lhost

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept lowner prompt 'Link owner....... '
	accept lname  prompt 'Link name........ '
	accept lhost  prompt 'Link host........ '
SET TERMOUT off;
	COLUMN lowner NEW_VALUE _lowner ;
	COLUMN lname  NEW_VALUE _lname ;
	COLUMN lhost  NEW_VALUE _lhost ;
	select case when '&&lowner' IS NULL then 'ALL' else     upper('&&lowner') end as lowner from dual;
	select case when '&&lname'  IS NULL then 'ALL' else     upper('&&lname')  end as lname  from dual;
	select case when '&&lhost'  IS NULL then 'ALL' else     upper('&&lhost')  end as lhost  from dual;
SET TERMOUT on;


BREAK ON owner ;

  select * 
    from dba_db_links
   where ( owner       like '%&&_lowner%' OR  'ALL' = '&&_lowner' )
     and ( db_link     like '%&&_lname%'  OR  'ALL' = '&&_lname' )
     and ( upper(host) like '%&&_lhost%'  OR  'ALL' = '&&_lhost' )
order by owner, db_link;

CLEAR BREAKS;


UNDEF lowner
UNDEF lname
UNDEF lhost
