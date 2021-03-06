Set-PSDebug -Strict
$workingDirectory = 'C:\Temp\ALP Build'

if (Test-Path $workingDirectory) {
    Remove-Item -Path $workingDir\* -Recurse -Force
} else {
    New-Item -Path $workingDirectory -ItemType Directory
}

$startInfo = New-Object Diagnostics.ProcessStartInfo('C:\Program Files\7-Zip\7z.exe')
$startInfo.UseShellExecute = $false
$arguments = 'x "{0}" -o"{1}"' -f 'C:\Projects\ALP\CMS\Sources\ALP.Web\CMSSiteUtils\Export\export_20100607_1809.zip',$workingDirectory
$startInfo.Arguments = $arguments
$process = [Diagnostics.Process]::Start($startInfo)
$process.WaitForExit()
$exitCode = $process.ExitCode
if ($exitCode -ne 0 ) { throw "Error extracting package. $exitCode" }

$settingsFile = Join-Path $workingDirectory 'Data\Objects\cms_settingskey.xml.export'


