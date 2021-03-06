Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
throw "Do not run the whole script!"

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

$remoteScript = {
    Add-PSSnapin "WebAdministration"
    $alp3AppPool = 'ALP Phase 3'
    if (Get-WebAppPoolState "$alp3AppPool`*") {Stop-WebAppPool $alp3AppPool}
    if (Get-WebAppPoolState "$alp3AppPool`*") {Start-WebAppPool $alp3AppPool}
}
Invoke-Command $remoteScript -ComputerName $computername

$appPool = Get-Item -Path 'IIS:\AppPools\ALP AppPool'
$appPool.processModel.pingingEnabled = $false
$appPool | Set-Item


Get-WmiObject -ComputerName $env:ComputerName,'CEBLDDEVSYD02','CETFSSYD01' -Class Win32_NetworkAdapter | `
  Where-Object { $_.Speed -ne $null -and $_.MACAddress -ne $null } | `
  Format-Table -Property SystemName,Name,NetConnectionID,@{Label='Speed(B)'; Expression = {'{0:#,###}' -f $_.Speed}}

Get-WmiObject -ComputerName $env:ComputerName -Class win32_OperatingSystem | Format-Table -Property CSName,CSDVersion

$computerName = 'ceblddevsyd02'
& 'C:\Projects\ALP\CMS\Build\DisconnectUsersFromAlpShare.ps1' $computerName

openfiles /query /s $computerName /v

Get-Process -ComputerName $computerName -Name 7z*

$ff = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
$sn = @{
    vdg = 'global.alpvic.dev.communityengine.com';
    v3dg = 'global.alpvic3.dev.communityengine.com';
    vig = 'global.alpvic.int.communityengine.com';
    v3ig = 'global.alpvic3.int.communityengine.com';
    vsg = 'global.alpvic.staging.communityengine.com';
    vpg = 'alpvictoria.com.au';
    fdg = 'global.alp.dev.communityengine.com';
    fig = 'global.alp.int.communityengine.com';
    fsg = 'global.alp.staging.communityengine.com';
    fpg = 'alp.org.au';
}
$smn = @{    
    vd = "$($sn.vdg)/cmssitemanager";
    v3d = "$($sn.v3dg)/cmssitemanager";
    vi = "$($sn.vig)/cmssitemanager";
    v3i = "$($sn.v3ig)/cmssitemanager";
    vs = "$($sn.vsg)/cmssitemanager";
    vp = "$($sn.vpg)/cmssitemanager";
    fd = "$($sn.fdg)/cmssitemanager";
    fi = "$($sn.fig)/cmssitemanager";
    fs = "$($sn.fsg)/cmssitemanager";
    fp = "$($sn.fpg)/cmssitemanager";
}
$sn
$smn

& $ff $smn.vi
ofi $sn.vpg
ofi action.alp.prod.communityengine.com
ofi action.alp.staging.communityengine.com

& 'C:\Projects\ALP\CMSVIC\Build\Deploy ALP Victoria.ps1' ALPVIC_20100817.2 'ALP Victoria' 'ALP Victoria' 192.168.100.95 Staging $false $false
C:\Projects\ALP\CMSVIC\Build

& 'C:\Projects\ALP\CMSVIC\ALP Dev Workstation Setup.ps1' 'ALP Victoria' 'ALP Victoria' '127.0.0.1' Dev

& "C:\Projects\ALP\CMSVIC3\Build\Package ALP.Web Since Last Deployment Date.ps1" -dateTimeFrom '2010-10-13T17:20:00' -dateTimeTo '2010-10-14T10:30:00'
& "C:\Projects\ALP\CMSVIC3\Build\Package ALP.Web Since Last Deployment Date.ps1" -dateTimeFrom '2010-12-15T11:15:00'

& "C:\Projects\ALP\CMS\Build\Package ALP.Web Since Last Deployment Date.ps1" -dateTimeFrom '2010-12-15T09:00:00'

& 'C:\Program Files (x86)\Internet Explorer\iexplore.exe'
& 'C:\Program Files\Internet Explorer\iexplore.exe' 'http://global.alp.prod.communityengine.com/Blogs/ALP-Blog/June-2010/test1.aspx'

gci . -Include *.png,*.jpg,*.jpeg,*.bmp,*.gif -Recurse | Sort-Object Length -Descending | % { Write-Output "$($_.Length)`t$($_.FullName)" } > C:\Temp\ALP.Web.Images.txt

$ErrorActionPreference = 'Stop' 'Continue'; 'Inquire'
"HERE"; Write-Error "error" ; "after"
$error.count
Resolve-ErrorRecord $error[0]
$?

New-EventLog -LogName Application -Source 'ALP Project'
Write-EventLog -LogName Application -EventId 3001 -Source 'ALP Project' -Message "ALP Deployment build  $buildnumber result = $?"

# Get Info about ALP Project File System
Set-Location C:\Projects\ALP\CMSVIC\Sources\ALP.Web

$fileCount = $directoryCount = 0;
Get-ChildItem | ForEach-Object { 
    if ($_.PSIsContainer) { $directoryCount += 1 } else { $fileCount += 1 }
}

"Files $fileCount. Directories $directoryCount"

Get-Item Default.aspx | fl *

handle actionsites

########## Running ALPFED.ActionSites Build Interactively
$projectFile = 'C:\ALP\ALPFED.ActionSites\BuildType\TFSBuild.proj'
Copy-Item C:\Projects\ALP\ActionSites\Build\TFSBuild.proj $projectFile -Force
Copy-Item 'C:\Projects\ALP\ActionSites\Build\Deploy ALPFED.ActionSites.ps1' 'c:\ALP\ALPFED.ActionSites\Sources\Build' -Force
Copy-Item 'C:\Projects\ALP\ActionSites\Build\Generate Configuration Files.ps1' 'c:\ALP\ALPFED.ActionSites\Sources\Build' -Force
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /T:ScriptDev /p:BuildNumber=ALPFED.ActionSites_20101028.1`;BuildDirectory=c:\ALP\ALPFED.ActionSites`;BuildDefinition=ALPFED.ActionSites`;SolutionRoot=c:\ALP\ALPFED.ActionSites\Sources`;DropLocation=\\CETFSSYD01\Release /v:d $projectFile

Copy-Item 'C:\Projects\ALP\ActionSites\Build\Deploy ALPFED.ActionSites.ps1' C:\CommunityEngine -Force
if (-not (Test-Path C:\CommunityEngine\ALPFED.ActionSites_20101028.1.zip)) { Copy-Item "C:\ALP\ALPFED.ActionSites\Package\ALPFED.ActionSites_20101028.1.zip" C:\CommunityEngine }
& 'C:\CommunityEngine\Deploy ALPFED.ActionSites.ps1'ALPFED.ActionSites_20101028.1 'C:\CommunityEngine\ALP Federal' 'ALP Federal Action' 'ALP Federal Action' 127.0.0.1 Dev -includeIIS


Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPFED.ActionSites.ps1' 'ALPFED.ActionSites_20101028.1' 'C:\CommunityEngine\ALP Federal' 'ALP Federal Action' 'ALP Federal Action' '192.168.100.37' 'Integration' -includeIIS }
Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPFED.ActionSites.ps1' 'ALPFED.ActionSites_20101028.1' 'C:\CommunityEngine\ALP Federal' 'ALP Federal Action' 'ALP Federal Action' '192.168.100.37' 'Integration' -includeIIS }

C:\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoLogo -NoProfile -Command "Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPFED.ActionSites.ps1' 'ALPFED.ActionSites_20101028.1' 'C:\CommunityEngine\ALP Federal' 'ALP Federal Action' 'ALP Federal Action' '192.168.100.37' 'Integration' -includeIIS }"
"`$LASTEXITCODE $LASTEXITCODE"
& "C:\Projects\ALP\ActionSites\Build\Generate Configuration Files.ps1" '..\trunk\src\web.config'

$fileName = 'C:\Projects\ALP\CMS\Build\Generate Configuration Files.ps1'
$psISE.CurrentPowerShellTab.Files.Add($fileName)

notepad "C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\PrivateAssemblies\tfsbuildservice.exe.config"
notepad "C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\PrivateAssemblies\tfsbuildservice2010.exe.config"

"C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\PrivateAssemblies\tfsbuildservice.exe"

######### Running ALPFED Build Interactively
$projectFile = 'C:\ALP\ALPFED\BuildType\TFSBuild.proj'
Copy-Item C:\Projects\ALP\CMS\Build\TFSBuild.proj $projectFile -Force
Copy-Item 'C:\Projects\ALP\CMS\Build\Deploy ALPFED.ps1' 'c:\ALP\ALPFED\Sources\Build' -Force
Copy-Item 'C:\Projects\ALP\CMS\Build\Generate Configuration Files.ps1' 'c:\ALP\ALPFED\Sources\Build' -Force
MSBuild.exe /T:ScriptDev /p:BuildNumber=ALPFED_20101103.2`;BuildDirectory=c:\ALP\ALPFED`;BuildDefinition=ALPFED`;SolutionRoot=c:\ALP\ALPFED\Sources`;DropLocation=\\CETFSSYD01\Release /v:d $projectFile

Copy-Item 'C:\Projects\ALP\CMS\Build\Deploy ALPFED.ps1' C:\CommunityEngine -Force
if (-not (Test-Path C:\CommunityEngine\ALPFED_20101103.2.zip)) { Copy-Item "C:\ALP\ALPFED\Package\ALPFED_20101103.2.zip" C:\CommunityEngine }
& 'C:\CommunityEngine\Deploy ALPFED.ps1' ALPFED_20101103.2 'C:\CommunityEngine\ALP Federal' 'ALP Federal' 'ALP Federal' 127.0.0.1 Dev -includeIIS

Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPFED.ps1' 'ALPFED_20101104.2' 'C:\CommunityEngine\ALP Federal' 'ALP Federal' 'ALP Federal' '192.168.100.23' 'Integration' }

######### Running ALPVIC Build Interactively
$projectFile = "C:\ALP\ALPVIC\BuildType\TFSBuild.proj"
Copy-Item "C:\Projects\ALP\CMSVIC\Build\TFSBuild.proj" $projectFile -Force
Copy-Item 'C:\Projects\ALP\CMSVIC\Build\Deploy ALPFED.ps1' 'C:\ALP\ALPVIC\Sources\Build' -Force
Copy-Item "C:\Projects\ALP\CMSVIC\Build\Generate Configuration Files.ps1" 'C:\ALP\ALPVIC\Sources\Build' -Force
MSBuild.exe /T:ScriptDev /p:BuildNumber=ALPVIC_20101104.4`;BuildDirectory=c:\ALP\ALPVIC`;BuildDefinition=ALPVIC`;SolutionRoot=c:\ALP\ALPVIC\Sources`;DropLocation=\\CETFSSYD01\Release /v:d $projectFile

Copy-Item 'C:\Projects\ALP\CMS\Build\Deploy ALPFED.ps1' C:\CommunityEngine -Force
#if (-not (Test-Path C:\CommunityEngine\ALPFED_20101103.2.zip)) { Copy-Item "C:\ALP\ALPFED\Package\ALPFED_20101103.2.zip" C:\CommunityEngine }
#& 'C:\CommunityEngine\Deploy ALPFED.ps1' ALPFED_20101103.2 'C:\CommunityEngine\ALP Federal' 'ALP Federal' 'ALP Federal' 127.0.0.1 Dev -includeIIS

Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPVIC3.ps1' 'ALPVIC3_20101105.2' 'C:\CommunityEngine\ALP Victoria 3' 'ALP Victoria 3' 'ALP Victoria 3' '192.168.100.55' 'Integration' -includeIIS }

########## Running ALPVIC.ActionSites Build Interactively
$sourceDirectory = 'C:\Projects\ALP\ActionSitesVIC'
$buildDefinitionName = 'ALPVIC.ActionSites'
$buildDirectory = "C:\ALP Build Interactive\ALP\$buildDefinitionName"
$buildNumber = 'ALPVIC.ActionSites_20101117.3'
$solutionRoot = "$buildDirectory\Sources"
$projectFile = "$buildDirectory\BuildType\TFSBuild.proj"
$deploymentLocalPath = "C:\CommunityEngine\ALP Victoria"
$webSiteName = "ALP Victoria Action"
$appPoolName = "ALP Victoria Action"
Copy-Item "$sourceDirectory\Build\Generate Configuration Files.ps1" "$buildDirectory\Sources\Build" -Force -Verbose
Copy-Item "$sourceDirectory\Build\Deploy $buildDefinitionName.ps1" "$buildDirectory\Sources\Build" -Force -Verbose
Copy-Item "$sourceDirectory\Build\TFSBuild.proj" $projectFile -Force -Verbose

C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe /T:ScriptDev /p:BuildNumber=$buildNumber`;BuildDirectory=$buildDirectory`;BuildDefinition=$buildDefinitionName`;SolutionRoot=$solutionRoot`;DropLocation=\\CETFSSYD01\Release /v:d $projectFile

Copy-Item "$sourceDirectory\Build\Deploy $buildDefinitionName.ps1" "$buildDirectory\Sources\Build" -Force -Verbose
Copy-Item "$buildDirectory\Sources\Build\Deploy $buildDefinitionName.ps1" C:\CommunityEngine -Force -Verbose
if (-not (Test-Path "C:\CommunityEngine\$buildNumber.zip")) { Copy-Item "$buildDirectory\Package\$buildNumber.zip" C:\CommunityEngine -Verbose }
& "C:\CommunityEngine\Deploy $buildDefinitionName.ps1" $buildNumber $deploymentLocalPath $webSiteName $appPoolName 127.0.0.1 Dev #-includeIIS

Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPVIC.ActionSites.ps1' 'ALPVIC.ActionSites_20101108.2' 'C:\CommunityEngine\ALP Victoria' 'ALP Victoria Action' 'ALP Victoria Action' '192.168.100.38' 'Integration' -includeIIS }

Get-WebAppPoolState 'ALP Victoria Action'

(Get-Item C:\Windows\system32\Httpapi.dll).VersionInfo | Format-Table -AutoSize
net use

$ceDirectory = "C:\CommunityEngine"
$federal = @{ BuildName = "ALPFED"; DeploymentLocalPath = "$ceDirectory\ALP Federal"; WebsiteName = 'ALP Federal'; AppPoolName = 'ALP Federal'; Ipaddress = '127.0.0.1'}
$federalAction = @{ BuildName = "ALPFED.ActionSites"; DeploymentLocalPath = "$ceDirectory\ALP Federal"; WebsiteName = 'ALP Federal Action'; AppPoolName = 'ALP Federal Action'; Ipaddress = ''}
$victoria = @{ BuildName = "ALPVIC"; DeploymentLocalPath = "$ceDirectory\ALP Victoria"; WebsiteName = 'ALP Victoria'; AppPoolName = 'ALP Victoria'; Ipaddress = ''}
$victoriaAction = @{ BuildName = "ALPVIC.ActionSites"; DeploymentLocalPath = "$ceDirectory\ALP Victoria"; WebsiteName = 'ALP Victoria Action'; AppPoolName = 'ALP Victoria Action'; Ipaddress = ''}
$victoria3 = @{ BuildName = "ALPVIC3"; DeploymentLocalPath = "$ceDirectory\ALP Victoria 3"; WebsiteName = 'ALP Victoria 3'; AppPoolName = 'ALP Victoria 3'; Ipaddress = ''}

$project = $federal

$mostRecentBuildPackage = Get-ChildItem (Join-Path $ceDirectory ($project.BuildName + '_*.zip')) | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Host "Deploying $($mostRecentBuildPackage.BaseName)"
&  "$ceDirectory\Deploy $($project.BuildName).ps1" $mostRecentBuildPackage.BaseName $project.DeploymentLocalPath $project.WebsiteName $project.AppPoolName $project.Ipaddress 'Dev' -includeIIS
