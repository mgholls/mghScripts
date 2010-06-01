$cp = Join-Path (Split-Path -Parent -Path $PROFILE) 'profile.ps1'

function Edit-File {

	param([string]$file)
	
	$editor = "$env:SystemRoot\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe"
	
	& $editor $file 
}

New-Alias -Name ef -Value Edit-File

function Edit-Profile { Edit-File $cp }
New-Alias -Name ep -Value Edit-Profile

. "C:\Working\GitProjects\mghScripts\DevUtilities.ps1"
Configure-VisualStudioCommandPrompt
Copy-Item -Path $cp -Destination 'C:\Working\GitProjects\mghScripts'

pushd C:\Working
