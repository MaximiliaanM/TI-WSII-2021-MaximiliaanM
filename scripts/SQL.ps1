# -------------------------------------------------------------------------
# Change hostname
# -------------------------------------------------------------------------
function changeHostname {
    $hostname = "EP3-SCCM"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
}
# -------------------------------------------------------------------------
# Change networksettings
# -------------------------------------------------------------------------
function changeNetworkSettings {
    $ip = "192.168.10.225" 
    $dns = "192.168.10.200"
    $gw = "192.168.10.200"
    New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses $gw, $dns
}
# -------------------------------------------------------------------------
# Join existing Domain
# -------------------------------------------------------------------------
function joinDomain {
    $domainname = "EP3-Maximiliaan.hogent"
    $username = "$domainname\Administrator"
    $password = "Administr@tor2022" | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    Add-Computer -DomainName $domainname -Credential $credential
}# -------------------------------------------------------------------------
# Change SQL Server (Perform on Server Core)
# -------------------------------------------------------------------------
Function changeSQL {
    $domainname = "EP3-Maximiliaan.hogent"
    Set-Location C:/packages
    Start-Process -FilePath ./SQLServer.exe -ArgumentList "/action=download /quiet /enu /MediaPath=C:/" -wait
    Remove-Item ./SQLServer.exe
    Start-Process -FilePath C:/SQLServer2019-x64-ENU.exe -WorkingDirectory C:/ /qs -wait
    C:/SQLServer2019-x64-ENU/SETUP.EXE /Q /ACTION="install" /IAcceptSQLServerLicenseTerms /FEATURES=SQL,RS,Tools /TCPENABLED=1 /SECURITYMODE=SQL /SQLSVCACCOUNT="$domainName\Administrator" /SQLSVCPASSWORD="Administr@tor2022" /SQLSYSADMINACCOUNTS="$domainName\Domain Admins" /INSTANCENAME=MSSQLSERVER /AGTSVCACCOUNT="$domainName\Administrator" /AGTSVCPASSWORD="Administr@tor2022" /SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS" -wait
}
# -------------------------------------------------------------------------
#Change SSMS installation (Best performed on jumpserver)
# -------------------------------------------------------------------------
Function changeSSMS {
    Set-Location C:/packages
    Start-Process -FilePath C:/packages/SSMS-Setup-ENU.exe -ArgumentList "/s" -Wait -PassThru
    Restart-Computer
}
changeHostname
changeNetworkSettings
joinDomain
changeSQL
changeSSMS