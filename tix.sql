spool &1 append;
@id
exec dbaudit.set_dba_role('&1');
select '&1' ticketnbr from dual;
