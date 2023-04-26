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

## reference links

- [List sessions / active connections on MySQL server](https://dataedo.com/kb/query/mysql/list-database-sessions)
- [MySQL show status - active or total connections?](https://stackoverflow.com/questions/7432241/mysql-show-status-active-or-total-connections)
- [MySQL SHOW USERS? – How to List All MySQL Users and Privileges](https://dbadiaries.com/no-mysql-show-users-how-to-list-mysql-user-accounts-and-their-privileges)
- [mysql: Show GRANTs for all users](https://dba.stackexchange.com/questions/23265/mysql-show-grants-for-all-users)
