@echo off
REM chcp 1251 - for Windows Server RU
chcp 1251
REM author: mayhems1
REM list of databases:
REM Database1
REM Database2
REM Database3
REM Database4
REM Database5

set "server_name=server1"

REM Retrieving login and password from a file, then setting the variables
for /F "tokens=1,2 delims==" %%i in (C:\scripts\credentials.txt) do (
    if "%%i"=="login" set login=%%j
    if "%%i"=="password" set password=%%j
)

setlocal

set "list_dbs=Database1 Database2 Database3 Database4 Database5"

for %%a in (%list_dbs%) do (
	echo ########################################################################### >> C:\scripts\logs\%%a_lunchtime.log
	echo Delete a backup of %%a at %date% and %time% >> C:\scripts\logs\%%a_lunchtime.log
	del H:\backup\%%a\lunchtime\* /q
	echo Backup of %%a started %date% and %time% >> C:\scripts\logs\%%a_lunchtime.log
	sqlcmd -S %server_name% -U %login% -P %password% -i C:\scripts\sql\backup_db_sql_script_lunchtime.sql -o C:\scripts\logs\%%a_run_lunchtime.log -v DBName="%%a"
	type C:\scripts\logs\%%a_run_lunchtime.log >> C:\scripts\logs\%%a_lunchtime.log
	del C:\scripts\logs\%%a_run_lunchtime.log
	echo Backup of %%a ended %date% and %time% >> C:\scripts\logs\%%a_lunchtime.log
)

endlocal
