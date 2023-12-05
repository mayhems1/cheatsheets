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

setlocal

set "list_dbs=Database1 Database2 Database3 Database4 Database5"

REM Periodically initiating backup for the list of databases
for %%a in (%list_dbs%) do (
	C:\scripts\backup_of_dbs.bat %%a
)

endlocal
