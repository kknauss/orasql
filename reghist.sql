column action_time   format a32 heading 'Time';
column action        format a16 heading 'Action';
column namespace     format a12 heading 'Namespace';
column version       format a10 heading 'Version';
column bundle_series format a7 heading 'Bundle|Series';
column comments      format a32 heading 'Comments';

select * from dba_registry_history order by action_time;
