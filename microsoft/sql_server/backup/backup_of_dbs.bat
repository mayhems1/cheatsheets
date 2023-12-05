@echo off
REM chcp 1251 - for Windows Server RU
chcp 1251
REM author: mayhems1

REM Vars
REM Checking for the presence of an argument (the argument is the name of the database. Available names are in README.txt)
if "%1"=="" (
    echo No argument provided. Available arguments:
    type README.txt
    exit /b
)

REM Assigning the value of the argument to the database variable
set "database=%1"
set "server_name=server1"
set "backup_file_name=%database%_%date%_%RANDOM%.7z"
set "backup_local_path=H:\backup\%database%"
set "backup_remote_path=\\remote-server1\backup\%database%"
set "log_file=C:\scripts\logs\%database%.log"
set "log_file_run=C:\scripts\logs\%database%_run.log"
set "log_file_evening=C:\scripts\logs\backups_evening.log"

REM Retrieving login and password from a file, then setting the variables
for /F "tokens=1,2 delims==" %%i in (C:\scripts\credentials.txt) do (
    if "%%i"=="login" set login=%%j
    if "%%i"=="password" set password=%%j
)

REM Number of days to keep backups on the remote-server1
set "days_to_keep_backups=42"
REM Parameters for monthly backups. Set for the 10th of each month when creating a monthly backup.
set "monthly_backup_to_remote_path=\\remote-server1\backup\%database%\monthly_backups"
set "day_of_monthly_backup=15"

REM Tasks, logging into two files, one detailed log_file, and another general for an overall understanding of completed tasks and time spent.
echo ############################################################################### >> %log_file%
echo ############################################################################### >> %log_file_evening%
echo Backup tasks of %database% started %date% and %time% >> %log_file%
echo Backup tasks of %database% started %date% and %time% >> %log_file_evening%

REM Backup using SQL tools
echo SQL Backup of %database% started %date% and %time% >> %log_file%
sqlcmd -S %server_name% -U %login% -P "%password%" -i C:\scripts\sql\backup_db_sql_script.sql -o %log_file_run% -v DBName="%database%"
REM Copying the output of sqlcmd to the backup log file and deleting the temporary file *_run.log
type %log_file_run% >> %log_file% && del %log_file_run%
echo SQL Backup of %database% ended %date% and %time% >> %log_file%

REM Compressing the nightly backup and deleting the SQL backup and the previous 7z copy
echo ZIP of %database% started %date% and %time% >> %log_file%
del %backup_local_path%\*.7z
"C:\Program Files\7-Zip\7z.exe" a -t7z %backup_local_path%\%backup_file_name% %backup_local_path%\*.bak >> %log_file% && del %backup_local_path%\*.bak
echo ZIP of %database% ended %date% and %time% >> %log_file%

REM Copying the 7z archive to the remote-server1
echo COPY backup of %database% started %date% and %time% >> %log_file%
robocopy %backup_local_path% %backup_remote_path%\ %backup_file_name% /NP >> %log_file%
echo COPY backup of %database% ended %date% and %time% >> %log_file%

REM Deleting old backups on the remote-server1 server
echo REMOVE oldest backup at %backup_remote_path% started %date% and %time% >> %log_file%
PowerShell -Command "& {Get-ChildItem -Path '%backup_remote_path%' | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-%days_to_keep_backups%)} | ForEach-Object { Add-Content -Path '%log_file%' -Value ('Removed file: ' + $_.FullName); Remove-Item $_.FullName -Force}}"
echo REMOVE oldest backup at %backup_remote_path% ended %date% and %time% >> %log_file%

REM Monthly backup, using the daily backup copy
REM Retrieving the current day of the month
for /f "tokens=1 delims=." %%a in ('echo %date%') do set day=%%a

REM Checking if the current day is the 10th, if so, then copy to a separate directory on remote-server1
if "%day%"=="%day_of_monthly_backup%" (
	echo COPY monthly backup file %backup_file_name% started %date% and %time% >> %log_file%
    robocopy %backup_local_path% %monthly_backup_to_remote_path%\ %backup_file_name% /NP >> %log_file%
    echo COPY monthly backup file %backup_file_name% ended %date% and %time% >> %log_file%
)

echo Backup tasks of %database% ended %date% and %time% >> %log_file%
echo Backup tasks of %database% ended %date% and %time% >> %log_file_evening%