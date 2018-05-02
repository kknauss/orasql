select * from dba_objects where owner = 'TCBS';


desc dba_role_privs

SELECT * from dba_tab_privs where grantee = 'FINANCE_SELECT';

select 'GRANT SELECT ON '||OWNER||'.'||TABLE_NAME||' TO FINANCE_SELECT;'
from dba_tables t
where owner = 'FINANCE' 
and not exists (select 1
                    from dba_tab_privs tp
                    where grantee = 'FINANCE_SELECT'
                    and tp.owner = t.owner
                    and tp.table_name = t.table_name
                    );

select 'GRANT SELECT ON '||OWNER||'.'||VIEW_NAME||' TO FINANCE_SELECT;'
from dba_views t
where owner = 'FINANCE' 
and not exists (select 1
                    from dba_tab_privs tp
                    where grantee = 'FINANCE_SELECT'
                    and tp.owner = t.owner
                    and tp.table_name = t.VIEW_NAME
                    );
                                        
                    
select 'GRANT SELECT ON '||OWNER||'.'||TABLE_NAME||' TO PSOFT_SELECT;'
from dba_tables t
where owner = 'PSOFT' 
and not exists (select 1
                    from dba_tab_privs tp
                    where grantee = 'PSOFT_SELECT'
                    and tp.owner = t.owner
                    and tp.table_name = t.table_name
                    );
                    
                    
select 'GRANT SELECT ON '||OWNER||'.'||TABLE_NAME||' TO RECON_SELECT;'
from dba_tables t
where owner = 'RECON' 
and not exists (select 1
                    from dba_tab_privs tp
                    where grantee = 'RECON_SELECT'
                    and tp.owner = t.owner
                    and tp.table_name = t.table_name
                    );
                    
                    
select 'GRANT SELECT ON '||OWNER||'.'||VIEW_NAME||' TO RECON_SELECT;'
from dba_views t
where owner = 'RECON' 
and not exists (select 1
                    from dba_tab_privs tp
                    where grantee = 'RECON_SELECT'
                    and tp.owner = t.owner
                    and tp.table_name = t.VIEW_NAME
                    );