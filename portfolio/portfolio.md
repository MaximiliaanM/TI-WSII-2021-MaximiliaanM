# Portfolio Windows Server II

## Opzetten omgeving

We hebben een golden image ISO dat we gebruiken om alle machine's op te zetten in VMware.
in deze golden image zit alle nodige scripts om de machine's op te zetten.
De ISO dat we gebruiken draait Windows Server 2019

### Domeincontroller

Om de domeincontroller te installeren voeren we het `DC1.ps1` script uit in een powershell CMD venster. Voer volgend command uit:

```powershell
PS> .\DC1.ps1
```

### WEB server

Om de web server te installeren voeren we het `IIS.ps1` script uit in een powershell CMD venster. Voer volgend command uit:

```powershell
PS> .\IIS.ps1
```

### Deployment server

Om de Deployment server te installeren voeren we het `SCCM.ps1` script uit in een powershell CMD venster. Voer volgend command uit:

```powershell
PS> .\SCCM.ps1
```

### Certificatie server

Om de Certificatie server te installeren voeren we het `CA.ps1` script uit in een powershell CMD venster. Voer volgend command uit:

```powershell
PS> .\CA.ps1
```