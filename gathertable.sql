BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
ownname  => '&owner',
tabname  => '&tablenm',
estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
block_sample => FALSE,
method_opt => 'FOR ALL INDEXED COLUMNS SIZE auto',
no_invalidate => FALSE,
CASCADE => TRUE);
COMMIT;
END;
/
