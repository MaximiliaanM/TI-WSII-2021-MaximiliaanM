# -------------------------------------------------------------------------
# Change hostname
# -------------------------------------------------------------------------
function changeHostname {
    $hostname = "EP3-CA"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
}
# -------------------------------------------------------------------------
# Change networksettings
# -------------------------------------------------------------------------
function changeNetworkSettings {
    $ip = "192.168.10.230" 
    $dns = "192.168.10.200"
    $gw = "192.168.10.200"
    New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $gw, $dns
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
}
# -------------------------------------------------------------------------
# Install the necessary prerequisites
# -------------------------------------------------------------------------
function changePrerequisites { 
    Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
    Add-WindowsFeature Adcs-Web-Enrollment
}
# -------------------------------------------------------------------------
# Installing CA
# -------------------------------------------------------------------------
function installCA {
    Install-AdcsCertificationAuthority -CAType StandaloneRootCa
    Install-AdcsWebEnrollment -CAConfig "EP3-CA\EP3-CA.EP3-Maximiliaan.hogent"
    Restart-computer
}
changeHostname
changeNetworkSettings
joinDomain
changePrerequisites
installCA