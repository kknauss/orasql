/*
 * Queries from
 * http://download.oracle.com/docs/cd/B19306_01/server.102/b14231/dbrm.htm#i1010776
*/



/*
Use the V$RSRC_CONSUMER_GROUP view to monitor CPU usage. It provides the cumulative amount of CPU time consumed by all sessions in each consumer group. It also provides a number of other measures helpful for tuning.
*/
SELECT NAME, CONSUMED_CPU_TIME FROM V$RSRC_CONSUMER_GROUP;

/*
V$RSRC_SESSION_INFO Use this view to monitor the status of a particular session. The view shows how the session has been affected by the Resource Manager. It provides information such as:
    *      The consumer group that the session currently belongs to
    *      The consumer group that the session originally belonged to
    *      The session attribute that was used to map the session to the consumer group
    *      Session state (RUNNING, WAIT_FOR_CPU, QUEUED, and so on)
    *      Current and cumulative statistics for metrics, such as CPU consumed, wait times, and queued time
*/
SELECT SE.SID SESS_ID, CO.NAME CONSUMER_GROUP, SE.STATE, SE.CONSUMED_CPU_TIME CPU_TIME, SE.CPU_WAIT_TIME, SE.QUEUED_TIME
FROM V$RSRC_SESSION_INFO SE, V$RSRC_CONSUMER_GROUP CO
WHERE SE.CURRENT_CONSUMER_GROUP_ID = CO.ID;


/*
This view shows when resource manager plans were enabled or disabled on the instance. It helps you understand how resources were shared among the consumer groups over time. For each entry in the view, the V$RSRC_CONS_GROUP_HISTORY view has a corresponding entry for each consumer group in the plan that shows the cumulative statistics for the consumer group.
*/
select * from V$RSRC_PLAN_HISTORY;

/* =============================================================================
DBA_RSRC_CONSUMER_GROUP_PRIVS
    DBA view lists all resource consumer groups and the users and roles to which they have been granted. USER view lists all resource consumer groups granted to the user.
DBA_RSRC_CONSUMER_GROUPS     Lists all resource consumer groups that exist in the database.
DBA_RSRC_MANAGER_SYSTEM_PRIVS
    DBA view lists all users and roles that have been granted Database Resource Manager system privileges. USER view lists all the users that are granted system privileges for the DBMS_RESOURCE_MANAGER package.
DBA_RSRC_PLAN_DIRECTIVES     Lists all resource plan directives that exist in the database.
DBA_RSRC_PLANS     Lists all resource plans that exist in the database.
DBA_RSRC_GROUP_MAPPINGS     Lists all of the various mapping pairs for all of the session attributes
DBA_RSRC_MAPPING_PRIORITY     Lists the current mapping priority of each attribute
DBA_USERS
    DBA view contains information about all users of the database. Specifically, for the Database Resource Manager, it contains the initial resource consumer group for the user. USER view contains information about the current user, and specifically, for the Database Resource Manager, it contains the current user's initial resource consumer group.
V$ACTIVE_SESS_POOL_MTH     Displays all available active session pool resource allocation methods.
V$BLOCKING_QUIESCE     Lists all sessions that could potentially block a quiesce operation. Includes sessions that are active and not in the SYS_GROUP consumer group.
V$PARALLEL_DEGREE_LIMIT_MTH     Displays all available parallel degree limit resource allocation methods.
V$QUEUEING_MTH     Displays all available queuing resource allocation methods.
V$RSRC_CONS_GROUP_HISTORY     For each entry in the view V$RSRC_PLAN_HISTORY, contains an entry for each consumer group in the plan showing the cumulative statistics for the consumer group.
V$RSRC_CONSUMER_GROUP     Displays information about active resource consumer groups. This view can be used for tuning.
V$RSRC_CONSUMER_GROUP_CPU_MTH     Displays all available CPU resource allocation methods for resource consumer groups.
V$RSRC_PLAN     Displays the names of all currently active resource plans.
V$RSRC_PLAN_CPU_MTH     Displays all available CPU resource allocation methods for resource plans.
V$RSRC_PLAN_HISTORY     Shows when Resource Manager plans were enabled or disabled on the instance. It helps you understand how resources were shared among the consumer groups over time.
V$RSRC_SESSION_INFO     Displays Resource Manager statistics for each session. Shows how the session has been affected by the Resource Manager. Can be used for tuning.
V$SESSION     Lists session information for each current session. Specifically, lists the name of the resource consumer group of each current session.
============================================================================= */
ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/yyyy hh24:mi:ss';

SELECT * FROM V$RSRC_PLAN_HISTORY;

/*
  Viewing Consumer Groups Granted to Users or Roles
  
  The DBA_RSRC_CONSUMER_GROUP_PRIVS view displays the consumer groups granted to users or roles. 
  Specifically, it displays the groups to which a user or role is allowed to belong or be switched. 
  For example, in the view shown below, user scott can belong to the consumer groups market or sales, 
  he has the ability to assign (grant) other users to the sales group but not the market group. 
  Neither group is his initial consumer group.
*/
SELECT * FROM DBA_RSRC_CONSUMER_GROUP_PRIVS;
SELECT * FROM DBA_RSRC_CONSUMER_GROUP_PRIVS where grantee like 'ERCM_CDD_LINK';
SELECT * FROM DBA_RSRC_CONSUMER_GROUP_PRIVS where grantee like 'ERCM_CDD_LINK';
SELECT * FROM DBA_RSRC_CONSUMER_GROUP_PRIVS where grantee like '%LINK%';


/*
Viewing Plan Schema Information

This example shows using the DBA_RSRC_PLANS view to display all of the resource plans defined in the database. All of the plans displayed are active, meaning they are not staged in the pending area
*/
SELECT PLAN,COMMENTS,STATUS FROM DBA_RSRC_PLANS;

/*
Viewing Current Consumer Groups for Sessions

You can use the V$SESSION view to display the consumer groups that are currently assigned to sessions.
*/
SELECT SID,SERIAL#,USERNAME,RESOURCE_CONSUMER_GROUP FROM V$SESSION;


/*
This example sets mydb_plan, as created by the statements shown earlier in "Multilevel Schema Example", as the top level plan. The V$RSRC_PLAN view is queried to display the currently active plans.

SQL> ALTER SYSTEM SET RESOURCE_MANAGER_PLAN = mydb_plan;

System altered.
*/
SELECT NAME, IS_TOP_PLAN FROM V$RSRC_PLAN;