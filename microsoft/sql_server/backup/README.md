# Backup scripts for MS SQL backup

## Instructions for using these scripts on Windows Server and MS SQL Server

File purposes:

- `README.txt` - list of databases for which backups should be created, informational file
- `backup_of_dbs.bat` - main script for creating backups, compressing them, and copying to a network server. Can be used manually, just specify the database name in the script argument
- `credentials.txt` - login and password for MS SQL
- `evening_backup_of_dbs.bat` - script for creating backups according to the list, can be used in Windows Task Scheduler
- `lunchtime_backup_of_dbs.bat` - script for creating lunchtime backups, backup without compression. The backup is overwritten, only the latest is kept.
- `sql\backup_db_sql_script_lunchtime.sql` - SQL script for creating a database backup and checking the lunchtime backup
- `sql\backup_db_sql_script.sql` - SQL script for creating a database backup and checking the backup

7-Zip or a portable version must be installed on the server, then change the path to 7-Zip in the backup_of_dbs.bat scripts

Script backup_of_dbs.bat using PowerShell for deleting old backups on the remote server. Verify that PowerShell is installed and can be used.

## Installation

Copy the following files and the sql folder to c:\scripts:

- README.txt
- backup_of_dbs.bat
- credentials.txt
- evening_backup_of_dbs.bat
- lunchtime_backup_of_dbs.bat
- sql (folder and SQL scripts)

Create a directory C:\scripts\log

Create a user in MS SQL Server with rights to create database backups.

Record the login and password in the credentials.txt file.

Create a separate user in Windows. This user will be used to run scripts in the Windows Task Scheduler and access the network folder.

Specify the list of databases in the list_dbs variable - evening_backup_of_dbs.bat and lunchtime_backup_of_dbs.bat

Specify the name of the MS SQL server in the server_name variable for the lunchtime_backup_of_dbs.bat and backup_of_dbs.bat scripts

In the backup_of_dbs.bat script, set the following variables depending on your environment:

- backup_local_path
- backup_remote_path
- days_to_keep_backups
- monthly_backup_to_remote_path
- day_of_monthly_backup

## Windows Task Scheduler

Create a simple task in Windows Task Scheduler to run scripts at the required time

For example:

13:30 - lunchtime_backup_of_dbs.bat

23:30 - evening_backup_of_dbs.bat
