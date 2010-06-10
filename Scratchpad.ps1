#$productionSettings = Import-Clixml -Path (Join-Path $workingDirectory 'ProductionSettings.xml')
#$stagingSettings = Import-Clixml -Path (Join-Path $workingDirectory 'StagingSettings.xml')

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


Invoke-Command $remoteScript -ComputerName $computername

Get-WmiObject -ComputerName $env:ComputerName,'CEBLDDEVSYD02','CETFSSYD01' -Class Win32_NetworkAdapter | `
  Where-Object { $_.Speed -ne $null -and $_.MACAddress -ne $null } | `
  Format-Table -Property SystemName,Name,NetConnectionID,@{Label='Speed(B)'; Expression = {'{0:#,###}' -f $_.Speed}}

Get-WmiObject -ComputerName $env:ComputerName -Class win32_OperatingSystem | Format-Table -Property CSName,CSDVersion

$computerName = 'ceblddevsyd02'
$pattern = '^.+ (?<FileId>\d+) (?<User>[^ ]+).+ (?<OpenFile>C:.+\\ALP3.*)$'
$openfiles = openfiles /query /s $computerName /v | Select-String -Pattern $pattern | ForEach-Object {[void]($_.Line -match $pattern); $matches['OpenFile']}
$openfiles | Sort-Object -Unique | ForEach-Object { openfiles /disconnect /s $computerName /a * /op `"$_`"}

openfiles /disconnect /s CEBLDDEVSYD02 /a * /op "C:\CommunityEngine\ALP3\ALP.Web\App_Browsers"

openfiles /query /s $computerName /v
