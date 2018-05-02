column ii          format 09 heading 'inst|id';
column sid         format 99999 heading 'sid';
column serial#     format 99999 heading 'serial#';
column opname      format a35 heading 'operation';
column target      format a40 heading 'target';
column username    format a26 heading 'username';
column event       format a28;
column elap_remain format a12 heading 'elapsed/|remain (s)';
column machine     format a24;
column sofar       format 999999999 heading 'blocks|processed';
column totalwork   format 999999999 heading 'total|blocks';
column blocksremain format 999999999 heading 'remaining|blocks';
column pctdone     format 990.99 heading '%|done';
column spid        format a8 heading 'server|pid';
column elapsed     format a11 heading 'elapsed|hhh:mm:ss' justify right;
column remaining   format a11 heading 'remain|hhh:mm:ss' justify righ;

UNDEF instid
UNDEF orasid

SET TERMOUT on;
	prompt
	prompt  Press ENTER for default (NULL) ...
	prompt
	accept instid prompt 'Instance ID...... '
	accept orasid prompt 'Session ID....... '
SET TERMOUT off;
	COLUMN instid NEW_VALUE _instid ;
	COLUMN orasid NEW_VALUE _orasid ;
	select case when '&&instid' IS NULL then 0     else to_number('&&instid') end as instid from dual;
	select case when '&&orasid' IS NULL then 0     else to_number('&&orasid') end as orasid from dual;
SET TERMOUT on;



select
	lo.inst_id ii,
	lo.SID,
	lo.serial#,
	p.spid,
	s.username,
	s.sql_id,
	lo.OPNAME,
	lo.target,
	lo.SOFAR,
	lo.TOTALWORK,
	lo.TOTALWORK- lo.SOFAR blocksremain,

--	to_char(lo.ELAPSED_SECONDS)||'/'||to_char(lo.TIME_REMAINING) elap_remain,

	lpad (
		to_char(lo.ELAPSED_SECONDS)||'/'||to_char(lo.TIME_REMAINING),
		length( to_char(lo.ELAPSED_SECONDS)||'/'||to_char(lo.TIME_REMAINING)) + 
		6 - instr ( to_char(lo.ELAPSED_SECONDS)||'/'||to_char(lo.TIME_REMAINING) , '/')
	) elap_remain,

	round(((lo.SOFAR/lo.TOTALWORK)*100),2) as pctdone ,
	     to_char(floor(    lo.elapsed_seconds/(60*60))            ,'0999')  ||':'||
	trim(to_char(floor(mod(lo.elapsed_seconds,(60*60))/60)          ,'09')) ||':'||
	trim(to_char(      mod(lo.elapsed_seconds,(60))                 ,'09'))
elapsed,
	     to_char(floor(    lo.time_remaining/(60*60))            ,'0999')  ||':'||
	trim(to_char(floor(mod(lo.time_remaining,(60*60))/60)          ,'09')) ||':'||
	trim(to_char(      mod(lo.time_remaining,(60))                 ,'09'))
remaining
    from gv$session_longops lo, gv$session s, gv$process p
   where lo.time_remaining > 0
     and lo.inst_id = s.inst_id
and s.inst_id        = p.inst_id(+)
and s.paddr          = p.addr(+)
     and lo.sid = s.sid
     and	( lo.inst_id = &&_instid                OR     0  =  &&_instid )
     and	( lo.sid = &&_orasid                    OR     0  =  &&_orasid )
order by lo.elapsed_seconds;
--order by lo.TIME_REMAINING;
