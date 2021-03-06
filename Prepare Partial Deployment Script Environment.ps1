Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$baseDirectory = 'C:\ALP Partial Deployment'
'ALPFED','ALPVIC' | ForEach-Object { 
    $basePath = Join-Path $baseDirectory $_
    'Build','Libraries','Sources' | ForEach-Object {
        $path = Join-Path $basePath $_
        if (-not (Test-Path $path)) { New-Item -Path $path -ItemType Directory }
    }
}

$tf = 'C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\TF.exe'
$collection = 'http://cetfssyd02:8080/tfs/ce%20projects'
$workspaceName = "$($env:COMPUTERNAME) ALP Partial Deployment"

& $tf workspace /new /collection:$collection /comment:"ALP Partial Deployment" $workspaceName

& $tf workfold /collection:$collection /workspace:$workspaceName /map '$/ALP/CMS/Build' "$baseDirectory\ALPFED\Build"
& $tf workfold /collection:$collection /workspace:$workspaceName /map '$/ALP/CMS/Libraries' "$baseDirectory\ALPFED\Libraries"
& $tf workfold /collection:$collection /workspace:$workspaceName /map '$/ALP/CMS/Sources' "$baseDirectory\ALPFED\Sources"
& $tf workfold /collection:$collection /workspace:$workspaceName /map '$/ALP/CMSVIC3/Build' "$baseDirectory\ALPVIC\Build"
& $tf workfold /collection:$collection /workspace:$workspaceName /map '$/ALP/CMSVIC3/Libraries' "$baseDirectory\ALPVIC\Libraries"
& $tf workfold /collection:$collection /workspace:$workspaceName /map '$/ALP/CMSVIC3/Sources' "$baseDirectory\ALPVIC\Sources"

$?
"Last Exit Code: $LASTEXITCODE"