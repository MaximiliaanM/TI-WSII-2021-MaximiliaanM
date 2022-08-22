# -------------------------------------------------------------------------
# Install the necessary prerequisites
# -------------------------------------------------------------------------
function changePrerequisites { 
    Write-Host "Installing prerequisites....."
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
    Write-Host "Installing Windows 10 ADK....."
    Set-Location C:/packages
    ADK.exe /installpath "C:\Program Files (x86)\Windows Kits\10" /features OptionId.DeploymentTools OptionId.UserStateMigrationTool OptionId.WindowsPreinstallationEnvironment /ceip off /norestart
}
# -------------------------------------------------------------------------
# Installing WSUS Features
# -------------------------------------------------------------------------
function installWSUS {
    Write-Host "Installing WSUS features....."
    Install-WindowsFeature -Name UpdateServices-Services, UpdateServices-DB -IncludeManagementTools
}
# -------------------------------------------------------------------------
# Installing MDT
# -------------------------------------------------------------------------
function installMDT {
    Write-Host "Installing MDT....."
    Set-Location C:/packages
    msiexec.exe /i .\MDT.msi /qb /quiet
}

# -------------------------------------------------------------------------
# Installing SCCM 
# -------------------------------------------------------------------------
function installSCCM {
    Write-Host "Installing SCCM....."
    Set-Location C:/packages
    ConfigMgr.exe /script .\Config.ini
    Restart-Computer
}
changePrerequisites
installADK
installWSUS
installMDT
installSCCM