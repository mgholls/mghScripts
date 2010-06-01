function Set-TFSOnline {

    param([string]$tfsServer = 'cetfssyd01')
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\VisualStudio\9.0\TeamFoundation\Servers\$tfsServer" -Name Offline -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\VisualStudio\9.0\TeamFoundation\Servers\$tfsServer" -Name AutoReconnect -Value 1
}

function Configure-VisualStudioCommandPrompt {
    #Set environment variables for Visual Studio Command Prompt
    pushd 'C:\Program Files (x86)\Microsoft Visual Studio 9.0\vc'
    cmd /c “vcvarsall.bat&set” |
    foreach {
      if ($_ -match “=”) {
        $v = $_.split(“=”); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
      }
    }
    popd
    write-host "`nVisual Studio 2008 Command Prompt variables set." -ForegroundColor Yellow
}

function OpenFresh-InternetExplorer {
    param([string]$url)
    
    Get-Process iexplore* | Foreach-Object { $_.Kill() } ; & 'C:\Program Files\Internet Explorer\iexplore.exe' -private $url
}

New-Alias ofi OpenFresh-InternetExplorer

function Configure-KentioCMS {
    # Probably need to look at Application_Start in Global.asax.cs for inspiration
    
    [Configuration.ConfigurationManager]::OpenExeConfiguration("C:\Working\Scripts\Kentico.config")
    [Configuration.ConfigurationManager]::RefreshSection("ConnectionStrings")
   
    [system.reflection.assembly]::loadwithpartialname("System.Configuration")
    [System.Reflection.Assembly]::LoadFrom("C:\inetpub\wwwroot\KenticoCMS\Bin\CMS.SiteProvider.dll")
    $sitesTable = [CMS.SiteProvider.SiteInfoProvider]::GetAllSites()
    $sitesTable.Tables[0].SiteName
    $siteInfo = [CMS.SiteProvider.SiteInfoProvider]::GetSiteInfo("MGHKentico")
    $siteInfo.Description += " - added by ps"
    [CMS.SiteProvider.SiteInfoProvider]::SetSiteInfo($siteInfo)
    [System.Reflection.Assembly]::LoadFrom("C:\Projects\ALP\CMS\Sources\ALP.Web\Bin\CMS.CMSHelper.dll")
    [CMS.CMSHelper.CMSContext]::Init()
}

function Update-Webfarm {
    $numberOfServers = 2
    $updaterUrl = "http://alp.prod.communityengine.com/CMSPages/WebFarmUpdater.aspx"
    1..$numberOfServers | ForEach-Object {
        [void](New-Object Net.WebClient).DownloadString($updaterUrl)
    }
}
