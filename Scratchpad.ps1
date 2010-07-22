Set-PSDebug -Strict

Set-PSDebug -Off

Write-Clipboard $env:COMPUTERNAME

& "C:\Projects\ALP\CMS\Build\Deploy ALP.CMS.ps1" 'ALP Phase 3' 'ALP Phase 3' '127.0.0.1' $false
& 'C:\Projects\ALP\CMS\Build\StartDeployment.ps1' ceblddevsyd02 'ALP Victoria' 'ALP Victoria' '192.168.100.24' $false

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

$computername = 'CEBLDDEVSYD02'

$remoteScript = {
    Add-PSSnapin "WebAdministration"
    $alp3AppPool = 'ALP Phase 3'
    if (Get-WebAppPoolState "$alp3AppPool`*") {Stop-WebAppPool $alp3AppPool}
    if (Get-WebAppPoolState "$alp3AppPool`*") {Start-WebAppPool $alp3AppPool}
}

$appPool = Get-Item -Path 'IIS:\AppPools\ALP AppPool'
$appPool.processModel.pingingEnabled = $false
$appPool | Set-Item

Invoke-Command $remoteScript -ComputerName $computername

Get-WmiObject -ComputerName $env:ComputerName,'CEBLDDEVSYD02','CETFSSYD01' -Class Win32_NetworkAdapter | `
  Where-Object { $_.Speed -ne $null -and $_.MACAddress -ne $null } | `
  Format-Table -Property SystemName,Name,NetConnectionID,@{Label='Speed(B)'; Expression = {'{0:#,###}' -f $_.Speed}}

Get-WmiObject -ComputerName $env:ComputerName -Class win32_OperatingSystem | Format-Table -Property CSName,CSDVersion

$computerName = 'ceblddevsyd02'
& 'C:\Projects\ALP\CMS\Build\DisconnectUsersFromAlpShare.ps1' $computerName

openfiles /query /s $computerName /v

Get-Process -ComputerName $computerName -Name 7z*

ofi alpvic.dev.communityengine.com
ofi global.alp.dev.communityengine.com

ofi global.alpvic.int.communityengine.com
ofi global.alp.int.communityengine.com

ofi global.alp.staging.communityengine.com
ofi connect.alp.staging.communityengine.com

ofi www.alp.org.au
ofi action.alp.prod.communityengine.com/cmssitemanager/

& "C:\ALP.Web Deployment\Build\Package ALP.Web Since Last Deployment Date.ps1" -lastDeployDate '2010-06-23T00:00:00'
& "C:\Projects\ALP\CMS\Build\Package ALP.Web Since Last Deployment Date.ps1" -lastDeployDate '2010-06-23T00:00:00'

& 'C:\Program Files (x86)\Internet Explorer\iexplore.exe'
& 'C:\Program Files\Internet Explorer\iexplore.exe' 'http://global.alp.prod.communityengine.com/Blogs/ALP-Blog/June-2010/test1.aspx'

gci . -Include *.png,*.jpg,*.jpeg,*.bmp,*.gif -Recurse | Sort-Object Length -Descending | % { Write-Output "$($_.Length)`t$($_.FullName)" } > C:\Temp\ALP.Web.Images.txt

$ErrorActionPreference = 'Stop' 'Continue'; 'Inquire'
"HERE"; Write-Error "error" ; "after"
$error.count
Resolve-ErrorRecord $error[0]
$?
