column acl        format   a60 heading 'Access Control List (ACL)';
column host       format   a24 heading 'Host';
column lower_port format 99999 heading 'Lower|Port';
column upper_port format 99999 heading 'Upper|Port';
column principal  format   a18 heading 'Principal';
column privilege  format   a28 heading 'Privilege';
column is_grant   format    a8 heading 'Is|Granted?';
column invert     format    a8 heading 'Inverted|Princpl?';

BREAK ON acl SKIP 1 ON REPORT skip 1;

select	na.acl,
	na.host,
	na.lower_port,
	na.upper_port,
	ap.principal,
	ap.privilege,
	case ap.is_grant when 'true' then 'yes' else 'no' end is_grant,
	case ap.invert   when 'true' then 'yes' else 'no' end invert
from	dba_network_acls na,
	dba_network_acl_privileges ap
where	na.acl = ap.acl
order by acl, host, principal, privilege;
