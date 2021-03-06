$buildSettings = @{ BuildName = 'ALPVIC.Donation'; BuildNumber = 'ALPVIC.Donation_20101214.3' }
$ceDirectory = "C:\CommunityEngine"
Copy-Item "C:\Builds\5\ALP\ALPVIC.Donation\Package\ALPVIC.Donation_20101214.3.zip" $ceDirectory -Verbose

$federal = @{ BuildName = "ALPFED"; DeploymentLocalPath = "$ceDirectory\ALP Federal"; WebsiteName = 'ALP Federal'; AppPoolName = 'ALP Federal'; Ipaddress = '127.0.0.1'}
$federalAction = @{ BuildName = "ALPFED.ActionSites"; DeploymentLocalPath = "$ceDirectory\ALP Federal"; WebsiteName = 'ALP Federal Action'; AppPoolName = 'ALP Federal Action'; Ipaddress = ''}
$victoria = @{ BuildName = "ALPVIC"; DeploymentLocalPath = "$ceDirectory\ALP Victoria"; WebsiteName = 'ALP Victoria'; AppPoolName = 'ALP Victoria'; Ipaddress = ''}
$victoriaAction = @{ BuildName = "ALPVIC.ActionSites"; DeploymentLocalPath = "$ceDirectory\ALP Victoria"; WebsiteName = 'ALP Victoria Action'; AppPoolName = 'ALP Victoria Action'; Ipaddress = ''}
$victoria3 = @{ BuildName = "ALPVIC3"; DeploymentLocalPath = "$ceDirectory\ALP Victoria 3"; WebsiteName = 'ALP Victoria 3'; AppPoolName = 'ALP Victoria 3'; Ipaddress = ''}

$victoriaDonation = @{ BuildName = "ALPVIC.Donation"; DeploymentLocalPath = "$ceDirectory\ALP Victoria"; WebsiteName = 'ALP Victoria Donation'; AppPoolName = 'ALP Victoria Donation'; 
    ManagedPipelineMode = 'Integrated'; ManagedRuntimeVersion = 'v2.0'; IncludeCustomErrors = $false ; Ipaddress = '127.0.0.1'}
$project = $victoriaDonation

Copy-Item "C:\Projects\ALP\DonationVIC\Build\Deploy.ps1" "$ceDirectory\Deploy $($buildSettings.BuildName).ps1" -Force -Verbose
# $psISE.CurrentPowerShellTab.Files.Add("$ceDirectory\Deploy $($project.BuildName).ps1")

$mostRecentBuildPackage = Get-ChildItem (Join-Path $ceDirectory ($project.BuildName + '_*.zip')) | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Host "Deploying $($mostRecentBuildPackage.BaseName)"
& "$ceDirectory\Deploy $($project.BuildName).ps1" $mostRecentBuildPackage.BaseName $project.DeploymentLocalPath $project.WebsiteName $project.AppPoolName $project.Ipaddress $project.ManagedPipelineMode $project.ManagedRuntimeVersion 'Dev' $project.IncludeCustomErrors -includeIIS

powershell.exe


Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { & 'C:\CommunityEngine\Deploy ALPVIC.Donation.ps1' 'ALPVIC.Donation_20101215.3' 'C:\CommunityEngine\ALP Victoria' 'ALP Victoria Donation' 'ALP Victoria Donation' '*' 'Integrated' 'v2.0' 'Integration' $false }

"-NoLogo -NoProfile -Command Invoke-Command -ComputerName CEBLDDEVSYD02 -ScriptBlock { ^& 'C:\CommunityEngine\Deploy ALPVIC.Donation.ps1' 'ALPVIC.Donation_20101215.3' 'C:\CommunityEngine\ALP Victoria' 'ALP Victoria Donation' 'ALP Victoria Donation' '*' 'Integrated' 'v2.0' 'Integration' $false }" -f 
'CEBLDDEVSYD02'

[String]::Format("-NoLogo -NoProfile -Command Invoke-Command -ComputerName {0} -ScriptBlock { & 'C:\CommunityEngine\Deploy {1}.ps1' '{2}' '{3}' '{4}' '{5}' '{6]' '{7}' '{8}' '{9}' {10} }", 'CEBLDDEVSYD02', 'ALPVIC.Donation', 'ALPVIC.Donation_20101214.3', 'C:\CommunityEngine\ALP Victoria', 'ALP Victoria Donation', 'ALP Victoria Donation', '*', 'Integrated', 'v2.0', 'Integration', 'false')

[String]::Format("Hello '{0}', How are you. '{1}'", 'Martin', 'Good')