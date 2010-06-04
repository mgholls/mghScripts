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

Copy-Item -Path $Profile.CurrentUserAllHosts -Destination (Join-Path 'C:\Working\GitProjects\mghScripts' "CurrentUserAllHosts.profile.ps1")

pushd C:\Working
