#$productionSettings = Import-Clixml -Path (Join-Path $workingDirectory 'ProductionSettings.xml')
#$stagingSettings = Import-Clixml -Path (Join-Path $workingDirectory 'StagingSettings.xml')

& 'C:\Projects\ALP\Config\Generate ALP.CMS Configuration Files.ps1' 'C:\Projects\ALP\CMS\Sources\ALP.Web\web.config'