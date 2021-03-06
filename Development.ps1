Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$DebugPreference = 'SilentlyContinue'
#throw "Do not run the whole script!"

function CountFiles {
    param ([Parameter(Mandatory=$true)]$directoryPath)
    if (-not (Test-Path $directoryPath)) { throw "Cannot access $directoryPath" }
    Write-Debug "Checking $directoryPath"
    $count = 0
    Get-ChildItem -Path $directoryPath | ForEach-Object {
        if ($_.PSIsContainer) {
            $count += CountFiles $_.FullName        
        } else {
            $count += 1
        }
    }
    if ($count -gt 5000) { Write-Host "$count $directoryPath" }
    $count
}

$path = "C:\Projects\ALP\CMSVIC\Sources\ALP.Web"
$path = "C:\Projects\ALP"

CountFiles (Resolve-Path $path)

#Resolve-Path (Resolve-Path ".")
