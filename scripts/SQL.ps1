# -------------------------------------------------------------------------
# Change hostname before joining domain
# -------------------------------------------------------------------------
function changeHostname {
    $hostname = "EP1-SQL"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
    Restart-Computer
}
# -------------------------------------------------------------------------
# Change networksettings
# -------------------------------------------------------------------------
function changeNetworkSettings {
    $ip = "192.168.10.226"
    $gw = "192.168.10.200"
    $dns = "192.168.10.200"
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
# Change SQL Server (Perform on Server Core)
# -------------------------------------------------------------------------
Function changeSQL {
    $sqlDownloadLink = "https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQL2019-SSEI-Expr.exe"
    Set-Location C:/
    Invoke-WebRequest $sqlDownloadLink -OutFile SQLServer.exe
    Start-Process -FilePath ./SQLServer.exe -ArgumentList "/action=download /quiet /enu /MediaPath=C:/" -wait
    Remove-Item ./SQLServer.exe
    Start-Process -FilePath C:/SQLEXPR_x64_ENU.exe -WorkingDirectory C:/ /qs -wait
    Start-Process -FilePath C:/SQLEXPR_x64_ENU/SETUP.EXE -ArgumentList "/Q /Action=install /IAcceptSQLServerLicenseTerms /FEATURES=SQL,RS,Tools /TCPENABLED=1 /SECURITYMODE=`"SQL`" /SQLSVCACCOUNT="$domainName\Administrator" /SQLSYSADMINACCOUNTS=`"$domainName\Domain Admins`" /INSTANCENAME=`"MSSQLSERVER`" /INSTANCEID=`"SQL`" /AGTSVCACCOUNT="NT AUTHORITY\Network Service" SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /SQLSVCPASSWORD=`"P@ssw0rd`"" -wait
}
# -------------------------------------------------------------------------
#Change SSMS installation (Best performed on jumpserver)
# -------------------------------------------------------------------------
Function changeSSMS {
    $SSMSDownloadLink = "https://go.microsoft.com/fwlink/?linkid=858904"
    Set-Location C:/
    Invoke-WebRequest $SSMSDownloadLink -OutFile SSMS.exe
    Start-Process -FilePath "C:\SSMS.exe" -ArgumentList '/s' -Wait -PassThru
}