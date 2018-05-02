--ec sys.dbms_system.set_ev                   (&&sid, &&serial, 10046,  0, '');
--ec sys.dbms_system.set_sql_trace_in_session (&&sid, &&serial, FALSE);

EXECUTE DBMS_MONITOR.SESSION_TRACE_DISABLE(session_id => &&sid, serial_num => &&serial);
