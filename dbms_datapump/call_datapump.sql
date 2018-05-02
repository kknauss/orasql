select user, host_name, instance_name from v$instance;

prompt grant read, write on directory TMP to your_userid;
prompt grant exp_full_database to your_userid;
prompt grant imp_full_database to your_userid;



pause Press ENTER to continue ...

whenever sqlerror continue
exec dbaudit.set_dba_role('PAR214048');



pause Press ENTER to continue ...

@"C:\Documents and Settings\kknauss\Desktop\dbms_datapump\expdp.norows.parms.sql" 214048 DVUMS DATA_PUMP_DIR 0



pause Press ENTER to continue ...

@"C:\Documents and Settings\kknauss\Desktop\dbms_datapump\impdp.sqlfile.parms.sql" 214048 DVUMS DATA_PUMP_DIR TABLE LEAD_QUOTE
