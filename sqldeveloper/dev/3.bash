#sqldp -g -u kknauss -c jdbc:oracle:thin:@aix22:1521:IDB -f id.sql -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql

#sqldp -g -u kknauss -c jdbc:oracle:thin:@aix22:1521/IDB.world -f id.sql -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql


#sqldp -g -u knauss_dba -c "jdbc:oracle:thin:@(DESCRIPTION=(FAILOVER=on)(LOAD_BALANCE=yes)(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=oradw1.flagstar.com)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=oradw2.flagstar.com)(PORT=1521)))(CONNECT_DATA=(FAILOVER_MODE=(TYPE=select)(METHOD=basic))(SERVER=dedicated)(SERVICE_NAME=DW.world)))" -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql -f id.sql

#sqldp -g -u knauss_dba -c "jdbc:oracle:thin:@(DESCRIPTION= (FAILOVER=on)(LOAD_BALANCE=yes)(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=oradw1.flagstar.com)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=oradw2.flagstar.com)(PORT=1521)))(CONNECT_DATA=(FAILOVER_MODE=(TYPE=select)(METHOD=basic))(SERVER=dedicated)(SERVICE_NAME=DW.world)))" -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql -f id.sql

#sqldp -g -u kknauss -c jdbc:oracle:oci8:@ddw   -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql -f id.sql

#sqldp    -u kknauss -c jdbc:oracle:oci8:@ddw   -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql -f id.sql

#sqldp    -u kknauss -c jdbc:oracle:oci8:@ddw   -d -f 

#sqldp    -u kknauss -c jdbc:oracle:oci8:@ddw   -f -d 

#sqldp -g -u knauss_dba -c "jdbc:oracle:thin:@ (  DESCRIPTION= (FAILOVER=on)(LOAD_BALANCE=yes)(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=oradw1.flagstar.com)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=oradw2.flagstar.com)(PORT=1521)))(CONNECT_DATA=(FAILOVER_MODE=(TYPE=select)(METHOD=basic))(SERVER=dedicated)(SERVICE_NAME=DW.world)))" -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql -f id.sql



#sqldp -g -u -c -f -d
#
#sqldp    -u -c -f -d
#
#sqldp    -u -c -d -f id.sql
#
#sqldp    -u -c -f id.sql -d
#
#sqldp    -u -c -f id.sql -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql
#
#sqldp    -u -c -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql -f id.sql
#
#sqldp    -u kknauss -c ABCD -f id.sql -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql
#
#sqldp    -u kknauss -c kknauss@DIDB -f id.sql -d c:\\Docume~1\\kknauss\\Desktop\\Keith\\sql

./sqldp.exe    -g -u knauss_dba -c "(DESCRIPTION=    (ADDRESS=      (PROTOCOL=TCP)      (HOST=lawdbs1.staging)      (PORT=1521)    )    (CONNECT_DATA=      (SID=SLAW9)    )  )" -f abc.sql -d "C:\Documents and Settings\kknauss\Desktop"
#./sqldp.exe    -g -u knauss_dba -c "(description=    (ADDRESS=      (PROTOCOL=TCP)      (HOST=lawdbs1.staging)      (PORT=1521)    )    (CONNECT_DATA=      (SID=SLAW9)    )  )" -f abc.sql -d "C:\Documents and Settings\kknauss\Desktop"
