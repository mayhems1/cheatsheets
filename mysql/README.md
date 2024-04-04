# MySQL

## List sessions / active connections on MySQL server

```sql

show status where variable_name = 'threads_connected';

show processlist;
show full processlist;

select id, user, host, db, command, time, state, info
from information_schema.processlist;

show status where variable_name = 'Max_used_connections';

show session status;

show variables like "max_connections";

show global status like '%connection%';

-- other example

select count(host) from information_schema.processlist;

show status where variable_name = 'threads_connected';

select @@max_connections

select id,
       user,
       host,
       db,
       command,
       time,
       state,
       info
from information_schema.processlist;
```

## Kill a session

```sql
SHOW PROCESSLIST;
KILL 192;

-- kill all open connections with a single command
SELECT 
CONCAT('KILL ', id, ';') 
FROM INFORMATION_SCHEMA.PROCESSLIST 
WHERE `User` = 'some_user' 
AND `Host` = '192.168.1.1'
AND `db` = 'my_db';
```

## Show grants

```sql
SELECT * FROM mysql.user;
SELECT user, host FROM mysql.user;
select user,host,authentication_string,select_priv from mysql.user;
SHOW GRANTS FOR 'root'@'localhost';

-- Show user privileges for all MySQL users using SHOW GRANTS
SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user;

SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user INTO outfile '/tmp/show_grants.txt';
SOURCE /tmp/show_grants.txt

-- Using information_schema.user_privileges
SELECT * FROM information_schema.user_privileges;
```

```bash
# Use Percona Toolkit's pt-show-grants, for example:
pt-show-grants --host localhost --user root --ask-pass
```

## Other usefull commands

```sql
SELECT CURRENT_TIMESTAMP;
```

## Try to fix Mysql slave after relay log corrupted

```sql
show slave status\G
-- error Relay log read failure: Could not parse relay log event entry. The possible reasons are: the master's binary log is corrupted (you can check this by running 'mysqlbinlog' on the binary log), the slave's relay log is corrupted (you can check this by running 'mysqlbinlog' on the relay log), a network problem, or a bug in the master's or slave's MySQL code. If you want to check the master's binary log or slave's relay log, you will be able to know their names by issuing 'SHOW SLAVE STATUS' on this slave
-- status - Exec_Master_Log_Pos: 221245113
slave stop;

change master to master_log_file='LBMS-bin.000012',master_log_pos=221245113;
start slave;

```

## reference links

- [List sessions / active connections on MySQL server](https://dataedo.com/kb/query/mysql/list-database-sessions)
- [MySQL show status - active or total connections?](https://stackoverflow.com/questions/7432241/mysql-show-status-active-or-total-connections)
- [MySQL SHOW USERS? – How to List All MySQL Users and Privileges](https://dbadiaries.com/no-mysql-show-users-how-to-list-mysql-user-accounts-and-their-privileges)
- [mysql: Show GRANTs for all users](https://dba.stackexchange.com/questions/23265/mysql-show-grants-for-all-users)
- [How to kill MySQL connections](https://stackoverflow.com/questions/4932503/how-to-kill-mysql-connections)
- [Getting current number of connections in mysql](https://dba.stackexchange.com/questions/270791/getting-current-number-of-connections-in-mysql)
- [List sessions / active connections on MySQL server](https://dataedo.com/kb/query/mysql/list-database-sessions)
- [How-to fix Mysql slave after relay log corrupted](https://alexzeng.wordpress.com/2013/10/17/how-to-fix-mysql-slave-after-relay-log-corrupted/)
