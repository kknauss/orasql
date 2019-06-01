col machine format a48

select inst_id, username, count(*) , count(distinct machine) from gv$session where username in ( 'INTRANET_APPID','EASCRM_APPID', 'DM_FS_SVC_APPID', 'DW_MYLOANS_LINK') group by inst_id, username order by inst_id, username;

select machine, username, count(*) , count(distinct machine) from gv$session where username in ( 'INTRANET_APPID','EASCRM_APPID', 'DM_FS_SVC_APPID', 'DW_MYLOANS_LINK') group by machine, username order by machine, username;

select username, count(*) , count(distinct machine) from gv$session where username in ( 'INTRANET_APPID','EASCRM_APPID', 'DM_FS_SVC_APPID', 'DW_MYLOANS_LINK') group by username order by username;

select username, inst_id, count(*) , count(distinct machine) from gv$session where username in ( 'INTRANET_APPID','EASCRM_APPID', 'DM_FS_SVC_APPID', 'DW_MYLOANS_LINK') group by username, inst_id order by username;

