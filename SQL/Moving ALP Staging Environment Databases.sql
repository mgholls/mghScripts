Create Table SQLPerfStuff ([Database Name] sysname, [Log Size (MB)] decimal(15,8), [Log Space Used (%)] decimal(15,8), [Status] int)
Insert into SQLPerfStuff
Exec ('dbcc sqlperf(logspace)')
Select * from SQLPerfStuff order by [Database Name]
drop table SQLPerfStuff

BACKUP LOG [ALPVIC.CMS]
TO DISK = N'C:\Backup\ALPVIC.CMS.TransactionLog_Cleanup.bak' 
WITH NOFORMAT, INIT,  NAME = N'ALPVIC.CMS TransactionLog_Cleanup Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

use [ALPVIC.CMS]
go
DBCC Shrinkfile(2,100) -- SELECT * FROM sys.database_files; SELECT FILE_IDEX('ALPVIC.CMS_log')
use master
go

DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @backupPath VARCHAR(256) = 'C:\Backup\ALPVIC.CMS_Staging' + @filestamp + '.bak'; SELECT @backupPath
BACKUP DATABASE [ALPVIC.CMS] TO DISK = @backupPath 
	WITH NOFORMAT, INIT,  NAME = N'ALPVIC.CMS Staging Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

ALTER DATABASE [ALPVIC.CMS] SET OFFLINE
GO

BACKUP LOG [ALP.ActionSiteVIC]
TO DISK = N'C:\Backup\ALP.ActionSiteVIC.TransactionLog_Cleanup.bak' 
WITH NOFORMAT, INIT,  NAME = N'ALP.ActionSiteVIC TransactionLog_Cleanup Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

use [ALP.ActionSiteVIC]
go
DBCC Shrinkfile(2,100) -- SELECT * FROM sys.database_files; SELECT FILE_IDEX('ALP.ActionSite_log')
use master
go

DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @backupPath VARCHAR(256) = 'C:\Backup\ALP.ActionSiteVIC_Staging' + @filestamp + '.bak'; SELECT @backupPath
BACKUP DATABASE [ALP.ActionSiteVIC] TO DISK = @backupPath 
	WITH NOFORMAT, INIT,  NAME = N'ALP.ActionSiteVIC Staging Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

ALTER DATABASE [ALP.ActionSiteVIC] SET OFFLINE
GO

BACKUP LOG [ALPVIC.Donation]
TO DISK = N'C:\Backup\ALPVIC.Donation.TransactionLog_Cleanup.bak' 
WITH NOFORMAT, INIT,  NAME = N'ALPVIC.Donation TransactionLog_Cleanup Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

use [ALPVIC.Donation]
go
DBCC Shrinkfile(2,10) -- SELECT * FROM sys.database_files; SELECT FILE_IDEX('ALPVIC.Donation_log')
use master
go

DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @backupPath VARCHAR(256) = 'C:\Backup\ALPVIC.Donation_Staging' + @filestamp + '.bak'; SELECT @backupPath
BACKUP DATABASE [ALPVIC.Donation] TO DISK = @backupPath 
	WITH NOFORMAT, INIT,  NAME = N'ALPVIC.Donation Staging Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

ALTER DATABASE [ALPVIC.Donation] SET OFFLINE
GO

RAISERROR ('Switch Server to CESTGSYD01', 18, 0) WITH NOWAIT

DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @BackupPath VARCHAR(256) = 'D:\Backup\ALPVIC.CMS_Staging' + @filestamp + '.bak'; SELECT @backupPath
RESTORE DATABASE [ALPVIC.CMS] 
	FROM  DISK = @backupPath
	WITH  FILE = 1, MOVE N'ALPVIC.CMS' TO N'D:\Database\ALPVIC.CMS.mdf', MOVE N'ALPVIC.CMS_log' TO N'D:\Database\ALPVIC.CMS.LDF',  
	NOUNLOAD,  REPLACE,  STATS = 10
GO

DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @BackupPath VARCHAR(256) = 'D:\Backup\ALP.ActionSiteVIC_Staging' + @filestamp + '.bak'; SELECT @backupPath
RESTORE DATABASE [ALP.ActionSiteVIC] 
	FROM  DISK = @backupPath
	WITH  FILE = 1, MOVE N'ALPActionCMS' TO N'D:\Database\ALP.ActionSiteVIC.mdf', MOVE N'ALPActionCMS_log' TO N'D:\Database\ALP.ActionSiteVIC.LDF',  
	NOUNLOAD,  REPLACE,  STATS = 10
GO

DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @BackupPath VARCHAR(256) = 'D:\Backup\ALPVIC.Donation_Staging' + @filestamp + '.bak'; SELECT @backupPath
RESTORE DATABASE [ALPVIC.Donation] 
	FROM  DISK = @backupPath
	WITH  FILE = 1, MOVE N'ALPVIC.Donation' TO N'D:\Database\ALPVIC.Donation.mdf', MOVE N'ALPVIC.Donation_log' TO N'D:\Database\ALPVIC.Donation.LDF',  
	NOUNLOAD,  REPLACE,  STATS = 10
GO
