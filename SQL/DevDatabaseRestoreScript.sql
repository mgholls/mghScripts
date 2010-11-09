-- Shrink Transaction Log (Optional)
-- http://technet.microsoft.com/en-us/library/ms189493.aspx

BACKUP LOG [ALP.ActionSiteVIC]
TO DISK = N'C:\Backup\ALP.ActionSiteVIC.TransactionLog_Cleanup.bak' 
WITH NOFORMAT, INIT,  NAME = N'ALP.ActionSiteVIC TransactionLog_Cleanup Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

DBCC SQLPERF(LOGSPACE) 

USE [ALP.ActionSiteVIC]
GO

SELECT * FROM sys.database_files
SELECT FILE_IDEX('ALPActionCMS_log')
DBCC Shrinkfile(2,100)

-- STEP 1: Backup Development CEBLDDEVSYD02 [ALP.ActionSiteVIC_DEV]
DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @devBackupPath VARCHAR(256) = 'C:\Backup\ALP.ActionSiteVIC_DEV_' + @filestamp + '.bak'; SELECT @devBackupPath
BACKUP DATABASE [ALP.ActionSiteVIC_DEV] 
	TO DISK = @devBackupPath 
	WITH NOFORMAT, INIT,  NAME = N'ALP.ActionSiteVIC_DEV Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- STEP 2: Backup Integration CEBLDDEVSYD02 [ALP.ActionSiteVIC]
DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @integrationBackupPath VARCHAR(256) = 'C:\Backup\ALP.ActionSiteVIC_' + @filestamp + '.bak'; SELECT @integrationBackupPath
BACKUP DATABASE [ALP.ActionSiteVIC] 
	TO DISK = @integrationBackupPath 
	WITH NOFORMAT, INIT,  NAME = N'ALP.ActionSiteVIC Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- STEP 3: Forcefully disconnect all Development database connections. Do NOT use in production!
USE MASTER; ALTER DATABASE [ALP.ActionSiteVIC_DEV] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

-- STEP 4: Restore over Development CEBLDDEVSYD02 [ALP.ActionSiteVIC_DEV]
DECLARE @filestamp VARCHAR(8) = CONVERT(VARCHAR(8), GETDATE(), 112)
DECLARE @integrationBackupPath VARCHAR(256) = 'C:\Backup\ALP.ActionSiteVIC_' + @filestamp + '.bak'; SELECT @integrationBackupPath
RESTORE DATABASE [ALP.ActionSiteVIC_DEV] 
	FROM  DISK = @integrationBackupPath
	WITH  FILE = 1,  
	MOVE N'ALPActionCMS' TO N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\ALP.ActionSiteVIC_DEV.mdf',  
	MOVE N'ALPActionCMS_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\ALP.ActionSiteVIC_DEV.LDF',  
	NOUNLOAD,  REPLACE,  STATS = 10
GO

-- STEP 5: Update Kentico SiteDomainName and Content Staging Server
Use [ALP.ActionSiteVIC_DEV]
GO

UPDATE dbo.CMS_Site
SET SiteDomainName = REPLACE(SiteDomainName, '.int.', '.dev.')
WHERE SiteDomainName LIKE '%.int.%'

UPDATE dbo.Staging_Server
SET 
	ServerDisplayName = REPLACE(ServerDisplayName, 'Staging', 'Integration'), 
	ServerName = REPLACE(ServerName, 'staging', 'integration'),
	ServerURL = REPLACE(ServerURL, '.staging.', '.int.')
WHERE ServerName LIKE '%Staging'


-- Notes: Remember to clear the Kentico cache in order to see the new staging server setting values.




