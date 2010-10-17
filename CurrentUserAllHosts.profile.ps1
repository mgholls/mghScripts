Import-Module Pscx -arg @{TextEditor = "C:\Program Files (x86)\TextPad 5\TextPad.exe"}
$MaximumHistoryCount = 500

function Edit-Script {

	param([string]$file)
	
	$editor = "$env:SystemRoot\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe"
	
	& $editor $file 
}
New-Alias -Name es -Value Edit-Script

function Edit-Profile { Edit-Script $Profile.CurrentUserAllHosts }
New-Alias -Name mep -Value Edit-Profile

. "C:\Working\GitProjects\mghScripts\DevUtilities.ps1"
Configure-VisualStudioCommandPrompt

function GetFull-Help {
    param([string]$commandName = $(throw "A command name must be specified"))
    Get-Help -Full -Name $commandName | more
}
New-Alias -Name gfh GetFull-Help

function Get-TimeStamp {
    param($format = 'ddd dd/MM/yyy HH:mm:ssz',$writeToClipboard = $true)
    $timestamp = (Get-Date).ToString($format)
    Write-Host $timestamp
    if ($writeToClipboard) { Write-Clipboard -Object $timestamp -NoNewLine }
}
New-Alias -Name gts -Value Get-TimeStamp

function Get-FileTimeStamp { Get-TimeStamp 'yyyyMMdd-HHmm' }
New-Alias -Name gfs -Value Get-FileTimeStamp

Copy-Item -Path $Profile.CurrentUserAllHosts -Destination (Join-Path 'C:\Working\GitProjects\mghScripts' "CurrentUserAllHosts.profile.ps1")

function Add-Note {
    $notesFile = "$env:USERPROFILE\Documents\Notes.txt"
    if (-not (Test-Path $notesFile)) { New-Item $notesFile -ItemType File }
    
    $timestamp = (Get-Date).ToString('ddd dd/MM/yyy HH:mm:ssz')
    Out-File -FilePath $notesFile -Append -InputObject "${timestamp}: $args" 
}

New-Alias -Name an -Value Add-Note

pushd C:\Working

function Open-VisualStudio {
    & "C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe"
}

New-Alias -Name ovs -Value Open-VisualStudio