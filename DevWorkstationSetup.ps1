Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$components = 
    @{ Name = "Powershell 2.0 64-bit"; FileName = "Windows6.0-KB968930-x64.msu"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/2/8/6/28686477-3242-4E96-9009-30B16BED89AF/Windows6.0-KB968930-x64.msu" },
    @{ Name = "SlickRun"; FileName = "sr-setup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://www.bayden.com/dl/sr-setup.exe" },
    @{ Name = "ASP.NET MVC 2"; FileName = "AspNetMVC2_VS2008.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/7/B/1/7B11DE4E-0247-448E-8D39-7C9B12ABA1FF/AspNetMVC2_VS2008.exe" },
    @{ Name = "Kentico CMS 5.0"; FileName = "KenticoCMS_5_0.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "Z:\Kentico\Kentico 5.0\KenticoCMS_5_0.exe" },
    @{ Name = "Kentico 5.0.19 HotFix"; FileName = "HotFix_50_19_net35.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://devnet.kentico.com/Downloads/HotFix/5_0/HotFix_50_19_net35.zip" },
    @{ Name = "Kentico CMS 5.0 Documentation"; FileName = "KenticoCMS_5_0_Documentation.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "Z:\Kentico\Kentico 5.0\KenticoCMS_5_0_Documentation.exe" },
    @{ Name = "7-Zip 4.65 64-bit"; FileName = "7z465-x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://transact.dl.sourceforge.net/project/sevenzip/7-Zip/4.65/7z465-x64.msi" },
    @{ Name = "TextPad 5.3"; FileName = "txpeng531.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.textpad.com/download/v53/txpeng531.exe" },
    @{ Name = "UltraMon 3.0 64-bit"; FileName = "UltraMon_3.0.10_en_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://www.realtimesoft.com/files/UltraMon_3.0.10_en_x64.msi" },
    @{ Name = "PrivBar"; FileName = "PrivBar.1.0.3.0.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://aaronmargosis.members.winisp.net/PrivBar/PrivBar.1.0.3.0.zip" },
    @{ Name = "Reflector"; FileName = "reflector.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://downloads.red-gate.com/reflector.zip" },
    @{ Name = "Fiddler2"; FileName = "Fiddler2Setup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://www.fiddler2.com/dl/Fiddler2Setup.exe" },
    @{ Name = "Sysinternals Handle"; FileName = "Handle.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.sysinternals.com/Files/Handle.zip" },
    @{ Name = "Sysinternals Process Monitor"; FileName = "ProcessMonitor.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.sysinternals.com/Files/ProcessMonitor.zip" },
    @{ Name = "Sysinternals Process Explorer"; FileName = "ProcessExplorer.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.sysinternals.com/Files/ProcessExplorer.zip" },
    @{ Name = "Sysinternals DebugView"; FileName = "DebugView.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.sysinternals.com/Files/DebugView.zip" },
    @{ Name = "TFS 2008 Power Tools"; FileName = "tfpt.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/e/b/d/ebd11ebe-a9ab-436a-84f5-96788ba1a4aa/tfpt.msi" },
    @{ Name = "Google Chrome"; FileName = "ChromeSetup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={1778B993-8847-E7E9-E1F2-1CA1225F0067}&lang=en&browser=3&usagestats=0&appname=Google%20Chrome&needsadmin=false/update2/installers/ChromeSetup.exe" },
    @{ Name = "WinMerge"; FileName = "WinMerge-2.12.4-Setup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://transact.dl.sourceforge.net/project/winmerge/1. Stable versions/2.12.4/WinMerge-2.12.4-Setup.exe" },
    @{ Name = "Git 1.7.0.2 for Windows"; FileName = "Git-1.7.0.2-preview20100309.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://msysgit.googlecode.com/files/Git-1.7.0.2-preview20100309.exe" },
    @{ Name = "PowerShell Snap-in for IIS 7.0 64-Bit"; FileName = "iis7psprov_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/B/8/6/B8617908-B777-4A86-A629-FFD1094990BD/iis7psprov_x64.msi" },
    @{ Name = "PowerShell Community Extensions 2.0"; FileName = "Pscx-2.0.0.1.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.codeplex.com/Project/Download/FileDownload.aspx?ProjectName=Pscx&DownloadId=121340&FileTime=129181939650730000&Build=16694" },
    @{ Name = "Effective Windows PowerShell"; FileName = "Effective Windows PowerShell.pdf"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://public.bay.livefilestore.com/y1p-B2whDzEVomrbZbJy2uapCoRUV3lTMpxePBmFRLFO2ZJHmwpXzQYDCgvwpd26-qYPOjkuUUerD4-LT7Z-GePoQ/Effective Windows PowerShell.pdf?download" },
    @{ Name = "NUnit 2.5.5"; FileName = "NUnit-2.5.5.10112.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://launchpadlibrarian.net/45063621/NUnit-2.5.5.10112.msi" },
    @{ Name = "NirSoft DLL Export Viewer - x64 release"; FileName = "dllexp-x64.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://www.nirsoft.net/utils/dllexp-x64.zip" },
    @{ Name = "Windows Search 4.0 for Windows Vista x64 Edition"; FileName = "Windows6.0-KB940157-x64.msu"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/8/7/3/87393551-5469-417e-b7d2-a71b40167d74/Windows6.0-KB940157-x64.msu" },
    @{ Name = "Visual Studio® 2008 Web Deployment Projects - RTW"; FileName = "WebDeploymentSetup.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/0/5/b/05b4424b-5b9b-4961-8ec6-91e9f1741b2d/WebDeploymentSetup.msi" },
    @{ Name = "Log Parser 2.2"; FileName = "LogParser.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/f/f/1/ff1819f9-f702-48a5-bbc7-c9656bc74de8/LogParser.msi" },
    @{ Name = "IIS7 Administration Pack 64-Bit"; FileName = "AdminPack_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/E/4/A/E4AE01FF-0966-4420-992A-A00C6970221A/AdminPack_x64.msi" },
    @{ Name = "IIS7 URL Rewrite Module 2.0 64-Bit"; FileName = "rewrite_2.0_rtw_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/6/7/D/67D80164-7DD0-48AF-86E3-DE7A182D6815/rewrite_2.0_rtw_x64.msi" },
    @{ Name = "FileZilla Client"; FileName = "FileZilla_3.3.5.1_win32-setup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://d10xg45o6p6dbl.cloudfront.net/projects/f/filezilla/FileZilla_3.3.5.1_win32-setup.exe" },
    @{ Name = "Resharper 5.1"; FileName = "ReSharperSetup.5.1.1727.12.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download-ln.jetbrains.com/resharper/ReSharperSetup.5.1.1727.12.msi" },
    @{ Name = "SQL Server 2008 Books Online"; FileName = "SQLServer2008_BOLOct2009.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/C/8/A/C8A9B44B-D471-452B-AE40-4273B68EE6FE/SQLServer2008_BOLOct2009.msi" },
    @{ Name = "Visual Studio Team System 2008 Service Pack 1 Forward Compatibility Update for Team Foundation Server 2010 (Installer)"; FileName = "VS90SP1-KB974558-x86.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/A/1/9/A192B090-3EA7-4C51-947A-5ED296722B23/VS90SP1-KB974558-x86.exe" },
    @{ Name = "Xenu's Link Sleuth"; FileName = "XENU.ZIP"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://home.snafu.de/tilman/XENU.ZIP" },
    @{ Name = "IIS UrlScan 3.1 64-Bit"; FileName = "urlscan_v31_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/2/1/9/219764e5-533b-4ce7-95fe-d4e3b98eafea/urlscan_v31_x64.msi" },
    @{ Name = "NuGet Package Manager"; FileName = "NuGet.Tools.vsix"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.codeplex.com/Project/Download/FileDownload.aspx?ProjectName=nuget&DownloadId=165467&FileTime=129337316857470000&Build=17358" },
    @{ Name = "Visual Studio 2010 Web Deployment Projects - RTW "; FileName = "WebDeploymentSetup.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/D/9/7/D9795B5C-CEE4-409A-99A9-802310D3F7A5/WebDeploymentSetup.msi" }

$webClient = New-Object Net.WebClient
foreach($component in $components) {
    $cachedFilePath = Join-Path $component.CachePath $component.FileName
    if (!(Test-Path $cachedFilePath)) {
        "Downloading $($component.Name) to $cachedFilePath" 
        $webClient.DownloadFile($component.DownloadUrl, $cachedFilePath)
    }
    
    # if not instlled install
}

# Create Folder Structure
'C:\Temp', 'C:\Working\GitProjects', 'C:\Working\Outlook' | ForEach-Object {
    if (!(Test-Path $_)) { New-Item -Path $_ -ItemType Directory }
}

# Kentico CMS File Permissions
$kenticoDir = "C:\inetpub\wwwroot\KenticoCMS"
if (Test-Path $kenticoDir) {
    Write-Host "Setting permissions on $kenticoDir"
    $kenticoAcl = Get-Acl -Path $kenticoDir
    $networkServiceAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Network Service", "Modify", "Allow")
    $kenticoAcl.SetAccessRule($networkServiceAccessRule)
    # Set-Acl -Path $kenticoDir -AclObject $kenticoAcl
}

function ConfigureWorkstationNTFSPermissions {
    
    $fullSID = $env:USERDOMAIN +'\' + $env:USERNAME
    
    icacls $env:windir\System32\drivers\etc\hosts /grant:r "`"$fullSID`":(M)"
}

ConfigureWorkstationNTFSPermissions

ofi action.alpvic.prod.communityengine.com/cmssitemanager