$components = 
    @{ Name = "Powershell 2.0 64-bit"; FileName = "Windows6.0-KB968930-x64.msu"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/2/8/6/28686477-3242-4E96-9009-30B16BED89AF/Windows6.0-KB968930-x64.msu" },
    @{ Name = "ASP.NET MVC 2"; FileName = "AspNetMVC2_VS2008.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/7/B/1/7B11DE4E-0247-448E-8D39-7C9B12ABA1FF/AspNetMVC2_VS2008.exe" },
    @{ Name = "Kentico CMS 5.0"; FileName = "KenticoCMS_5_0.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "Z:\Kentico\Kentico 5.0\KenticoCMS_5_0.exe" },
    @{ Name = "Kentico CMS 5.0 Documentation"; FileName = "KenticoCMS_5_0_Documentation.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "Z:\Kentico\Kentico 5.0\KenticoCMS_5_0_Documentation.exe" },
    @{ Name = "7-Zip 4.65 64-bit"; FileName = "7z465-x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://transact.dl.sourceforge.net/project/sevenzip/7-Zip/4.65/7z465-x64.msi" },
    @{ Name = "TextPad 5.3"; FileName = "txpeng531.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.textpad.com/download/v53/txpeng531.exe" },
    @{ Name = "UltraMon 3.0 64-bit"; FileName = "UltraMon_3.0.10_en_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://www.realtimesoft.com/files/UltraMon_3.0.10_en_x64.msi" },
    @{ Name = "PrivBar"; FileName = "PrivBar.1.0.3.0.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://aaronmargosis.members.winisp.net/PrivBar/PrivBar.1.0.3.0.zip" },
    @{ Name = "Reflector"; FileName = "reflector.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://downloads.red-gate.com/reflector.zip" },
    @{ Name = "Fiddler2"; FileName = "Fiddler2Setup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://www.fiddler2.com/dl/Fiddler2Setup.exe" },
    @{ Name = "Sysinternals Handle"; FileName = "Handle.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.sysinternals.com/Files/Handle.zip" },
    @{ Name = "Sysinternals Process Monitor"; FileName = "ProcessMonitor.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.sysinternals.com/Files/ProcessMonitor.zip" },
    @{ Name = "TFS 2008 Power Tools"; FileName = "tfpt.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/e/b/d/ebd11ebe-a9ab-436a-84f5-96788ba1a4aa/tfpt.msi" },
    @{ Name = "Google Chrome"; FileName = "ChromeSetup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={1778B993-8847-E7E9-E1F2-1CA1225F0067}&lang=en&browser=3&usagestats=0&appname=Google%20Chrome&needsadmin=false/update2/installers/ChromeSetup.exe" },
    @{ Name = "WinMerge"; FileName = "WinMerge-2.12.4-Setup.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://transact.dl.sourceforge.net/project/winmerge/1. Stable versions/2.12.4/WinMerge-2.12.4-Setup.exe" },
    @{ Name = "Git 1.7.0.2 for Windows"; FileName = "Git-1.7.0.2-preview20100309.exe"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://msysgit.googlecode.com/files/Git-1.7.0.2-preview20100309.exe" },
    @{ Name = "PowerShell Snap-in for IIS 7.0 64-Bit"; FileName = "iis7psprov_x64.msi"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.microsoft.com/download/B/8/6/B8617908-B777-4A86-A629-FFD1094990BD/iis7psprov_x64.msi" },
    @{ Name = "PowerShell Community Extensions 2.0"; FileName = "Pscx-2.0.0.1.zip"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://download.codeplex.com/Project/Download/FileDownload.aspx?ProjectName=Pscx&DownloadId=121340&FileTime=129181939650730000&Build=16694" },
    @{ Name = "Effective Windows PowerShell"; FileName = "Effective Windows PowerShell.pdf"; CachePath = "C:\WorkingLow\Downloads"; DownloadUrl = "http://public.bay.livefilestore.com/y1p-B2whDzEVomrbZbJy2uapCoRUV3lTMpxePBmFRLFO2ZJHmwpXzQYDCgvwpd26-qYPOjkuUUerD4-LT7Z-GePoQ/Effective Windows PowerShell.pdf?download" }

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