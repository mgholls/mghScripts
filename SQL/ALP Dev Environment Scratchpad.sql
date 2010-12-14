RAISERROR ('Do not run the whole script', 20, 0) WITH NOWAIT, LOG

SELECT 'WHY AM I HERE?'

use [ALP.ActionSiteVIC_DEV]
go

select KeyID, KeyDisplayName, KeyValue, SiteID, KeyGUID, KeyLastModified, KeyDefaultValue from CMS_SettingsKey where SiteID in (select SiteID from CMS_Site where SiteName = 'mghdev') and
 KeyDisplayName = 'Page title prefix'
select * from CMS_SettingsKey where KeyDisplayName = 'Page title prefix'
  
KeyID,KeyDisplayName,KeyValue,SiteID,KeyGUID,KeyLastModified,KeyDefaultValue
23758,Page title prefix,NULL,131,830375FB-F2CA-42CB-817E-68E76E82082C,2010-11-18 16:28:22.937,My Site
23758,Page title prefix,custom,131,830375FB-F2CA-42CB-817E-68E76E82082C,2010-11-18 16:29:50.527,My Site
23758,Page title prefix,NULL,131,830375FB-F2CA-42CB-817E-68E76E82082C,2010-11-18 16:32:14.457,My Site