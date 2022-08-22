# -------------------------------------------------------------------------
# Change hostname
# -------------------------------------------------------------------------
function changeHostname {
    $hostname = "EP3-WEB"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
}
# -------------------------------------------------------------------------
# Change networksettings
# -------------------------------------------------------------------------
function changeNetworkSettings {
    $ip = "192.168.10.220" 
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
}
# -------------------------------------------------------------------------
# Installing IIS Server
# -------------------------------------------------------------------------
function serverProvisioning {
#Set Time Zone
Set-TimeZone -Name "Central Europe Standard Time" 

#Setup Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#Install IIS Webserver
Write-Host "We are installing IIS now, take a coffee and sit back..."
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging
Enable-WindowsOptionalFeature -Online -FeatureName IIS-LoggingLibraries
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpTracing
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Metabase
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic

#Install ASP.NET
Write-Host "Installing NET-Framework... " -ForegroundColor Green
Add-WindowsFeature NET-Framework-45-ASPNET
Write-Host "Installing NET-HTTP-Activation ..." -ForegroundColor Green
Add-WindowsFeature NET-WCF-HTTP-Activation45

#HTTPS SSL
Write-Host "HTTPS Certificate and binding"
$dnsName = 'EP3-Maximiliaan.HoGent'
# Create the Certificate (TODO: Use the CA)
$newCert = New-SelfSignedCertificate -DnsName $dnsName -CertStoreLocation cert:\LocalMachine\My


$siteName = 'Default Web Site'
# Create HTTPS binding
New-WebBinding -name $siteName -IP "*" -Port 443 -Protocol https
# get the web binding of the site
$binding = Get-WebBinding -Name $siteName -Protocol "https"
# set the ssl certificate
$binding.AddSslCertificate($newCert.GetCertHashString(), "My")
Write-Host "HTTPS Installed!"
Restart-Computer
}
changeHostname
changeNetworkSettings
joinDomain
serverProvisioning