DECLARE @pathName NVARCHAR(512)
DECLARE @backupSetId as INT
DECLARE @dbName NVARCHAR(512)

-- Setting the database name for backup
SET @dbName = '$(DBName)'

-- Setting the path for the backup, the path must be created manually
SET @pathName = 'H:\backup\' + @dbName + '\' + @dbName + '_full_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + '.bak'

-- Performing the backup
BACKUP DATABASE @dbName TO  DISK = @pathName WITH COPY_ONLY, NOFORMAT, NOINIT, NAME = @dbName, SKIP, NOREWIND, NOUNLOAD,  STATS = 10

-- Retrieving the ID of the last backup
SELECT @backupSetId = position FROM msdb..backupset WHERE database_name=@dbName AND backup_set_id=(SELECT MAX(backup_set_id) FROM msdb..backupset WHERE database_name=@dbName)

-- Checking that the backupSetId is found
IF @backupSetId IS NULL 
BEGIN 
    RAISERROR(N'Verification error. Backup information for the database "%s" not found.', 16, 1, @dbName) 
END

-- Backup verification
RESTORE VERIFYONLY FROM  DISK = @pathName WITH  FILE = @backupSetId, NOUNLOAD, NOREWIND
