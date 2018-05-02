--ec sys.dbms_system.set_ev                   (&&sid, &&serial, 10046, 12, '');
--ec sys.dbms_system.set_sql_trace_in_session (&&sid, &&serial, TRUE);

EXECUTE DBMS_MONITOR.SESSION_TRACE_ENABLE(session_id => &&sid, serial_num => &&serial, waits => TRUE, binds => TRUE);
