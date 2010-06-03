#$productionSettings = Import-Clixml -Path (Join-Path $workingDirectory 'ProductionSettings.xml')
#$stagingSettings = Import-Clixml -Path (Join-Path $workingDirectory 'StagingSettings.xml')

& 'C:\Projects\ALP\TeamBuildTypes\ALP.INT Phase 3\Generate ALP.CMS Configuration Files.ps1'

$cmsDirectories = 'C:\Projects\ALP\CMS\Sources\ALP.Web\CMSTransformations', 
    'C:\Projects\ALP\CMS\Sources\ALP.Web\CMSLayouts', 
    'C:\Projects\ALP\CMS\Sources\ALP.Web\CMSTemplateLayouts', 
    'C:\Projects\ALP\CMS\Sources\ALP.Web\CMSAdhocTemplateLayouts', 
    'C:\Projects\ALP\CMS\Sources\ALP.Web\CMSWebPartLayouts'

$cmsDirectories | % { Remove-Item -Path $_\* -Recurse -Force }
    
gci $cmsDirectories

$baseUrl = 'http://{0}/' -f 'localhost:1488'
$credential = New-Object 'Net.NetworkCredential' 'Administrator',$null
$credentialCache = New-Object 'Net.CredentialCache'
$credentialCache.Add((New-Object 'Uri' $baseUrl), 'Basic', $credential)
$webClient = New-Object 'Net.WebClient'
$webClient.Credentials = $credentialCache
$url = $baseUrl + 'CMSSiteManager/Administration/System/System_Deployment.aspx'
$webClient.DownloadString($url)

#oi 'http://localhost:1488/CMSSiteManager/Administration/System/System_Deployment.aspx?action=saveall'

Add-PSSnapin "WebAdministration"

$websiteName = 'ALP Phase 3'
$appPoolName = 'ALP Phase 3 AppPool'

if (Get-Item IIS:\Sites\$websiteName*) { Remove-Website $websiteName }
if (Get-WebAppPoolState -Name "$appPoolName*") { Remove-WebAppPool $appPoolName}

$appPool = New-WebAppPool $appPoolName
$appPool.managedPipelineMode = 'Classic'
$appPool | Set-Item

$ipaddress = ([System.Net.DNS]::GetHostAddresses($env:COMPUTERNAME) | Where-Object { $_.AddressFamily -eq 'InterNetwork' }).IPAddressToString
$ipaddress = '127.0.0.1'
$website = New-Website -Name $websiteName -PhysicalPath 'C:\Projects\ALP\CMS\Sources\ALP.Web' -ApplicationPool $appPoolName -IPAddress $ipaddress -Port 80
#$webConfig = Get-WebConfiguration -Filter 'system.webServer/security/authentication/anonymousAuthentication' -PSPath "IIS:\Sites\$websiteName"
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/anonymousAuthentication -name enabled -value true -PSPath IIS:\ -location $websiteName
#Get-WebConfigurationProperty -filter /system.webServer/security/authentication/anonymousAuthentication -name enabled -PSPath IIS:\ -location $websiteName

Enter-PSSession CESQLSTGSYD01
$alp3AppPool = 'ALP Phase 3'                                                                                                                                                                                                      
if (Get-WebAppPoolState "$alp3AppPool`*") {Stop-WebAppPool $alp3AppPool}                                                                                                                                                          
if (Get-WebAppPoolState "$alp3AppPool`*") {Start-WebAppPool $alp3AppPool}  
Exit-PSSession