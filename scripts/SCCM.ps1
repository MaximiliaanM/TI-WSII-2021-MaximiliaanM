# -------------------------------------------------------------------------
# Change hostname
# -------------------------------------------------------------------------
function changeHostname {
    $hostname = "EP1-SCCM"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
    Restart-Computer
}
# -------------------------------------------------------------------------
# Change networksettings
# -------------------------------------------------------------------------
function changeNetworkSettings {
    $ip = "192.168.10.225" 
    $dns = "192.168.10.200"
    $gw = "192.168.10.200"
    New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $gw, $dns
}
# -------------------------------------------------------------------------
# Join existing Domain
# -------------------------------------------------------------------------
function joinDomain {
    $domainname = "EP1-Maximiliaan.HoGent"
    $username = "$domainname\Administrator"
    $password = "P@ssw0rd" | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    Add-Computer -DomainName $domainname -Credential $credential
    Restart-computer
}
# -------------------------------------------------------------------------
# Install the necessary prerequisites
# -------------------------------------------------------------------------
function changePrerequisites { 
    Get-Module ServerManager
    Install-WindowsFeature Web-Windows-Auth         
    Install-WindowsFeature Web-ISAPI-Ext
    Install-WindowsFeature Web-Metabase
    Install-WindowsFeature Web-WMI
    Install-WindowsFeature BITS
    Install-WindowsFeature RDC
    Install-WindowsFeature NET-Framework-Features
    Install-WindowsFeature Web-Asp-Net
    Install-WindowsFeature Web-Asp-Net45
    Install-WindowsFeature NET-HTTP-Activation
    Install-WindowsFeature NET-Non-HTTP-Activ
    Install-WindowsFeature WDS
    dism /online /enable-feature /featurename:NetFX3 /all /Source:d:\sources\sxs /LimitAccess
}
# -------------------------------------------------------------------------
# Installing the Windows 10 ADK
# -------------------------------------------------------------------------
function installADK {
    $ADKDownloadLink = "http://go.microsoft.com/fwlink/p/?LinkId=526740&ocid=tia-235208000"
    Invoke-WebRequest $ADKDownloadLink -OutFile ADK.exe
    ADK.exe /installpath "C:\Program Files (x86)\Windows Kits\10" /features OptionId.DeploymentTools OptionId.UserStateMigrationTool OptionId.WindowsPreinstallationEnvironment /ceip off /norestart
}
# -------------------------------------------------------------------------
# Installing WSUS Features
# -------------------------------------------------------------------------
function installWSUS {
    Install-WindowsFeature -Name UpdateServices-Services, UpdateServices-DB -IncludeManagementTools
}
# -------------------------------------------------------------------------
# Installing SCCM 
# -------------------------------------------------------------------------
function installSCCM {
    # Add the downloadlink for the Config.ini file here!
    # Be sure to configure the necessary parameters (Domain; et al.) in the Config.ini!
    $ConfigDownloadLink = https://raw.githubusercontent.com/jensdufour/TI-WSRV-1819-JDF/master/scripts/Config.ini
    # Add the downloadlink for the SCCM Server 2016 iso here!
    $SCCMDownloadLink = http://download.microsoft.com/download/F/B/9/FB9B10A3-4517-4E03-87E6-8949551BC313/SC_Configmgr_SCEP_1606.exe
    Set-Location C:/
    Invoke-WebRequest $SCCMDownloadLink -OutFile ConfigMgr.exe
    #Mount-DiskImage -ImagePath .\SCCM.iso
    #$SCCMISOLocation = (Get-DiskImage ".\SCCM.iso" | Get-Volume).DriveLetter
    #Set-Location $SCCMISOLocation
    Invoke-WebRequest $ConfigDownloadLink -OutFile Config.ini
    ConfigMgr.exe /script .\Config.ini
}