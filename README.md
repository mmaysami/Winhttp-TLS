## TLS Activation Tools (Winhttp)
Enable TLS 1.1/1.2 Security Protocols as default for WinHTTP in older Windows Systems (Windows 7, 8 ...)

 - [Latest Release](https://github.com/mmaysami/Winhttp-TLS/releases/latest)

Applications and services that are written by using WinHTTP for 
Secure Sockets Layer (SSL) connections can't use TLS 1.1 / 1.2 protocols. 
This is because the definition of WinHTTP library doesn't include these 
newer protocols.

This update adds support for DefaultSecureProtocols registry entry that 
allows certain applications that were built to use the WinHTTP default 
flag to be able to leverage the newer TLS 1.2 or TLS 1.1 protocols 
natively without any need for updates to the application.

### Usage: 
 - Powershell Script: Run the scripts from the script misc directory, for example:
   - ``` Set-ExecutionPolicy Bypass -Scope Process ; & ".\Windows TLS Upgrade Tool.ps1" ```
 - Executable: Run the build script from the main directory, for example:
   - ``` ".\BuildTools.ps1" ```
   - Run *.EXE from ToolsEXE folders

 - Restart your workstation for the changes to take effect.


### Workflow:
#### Step 1 
This script downloads and installs the [KB3140245 Windows update](http://www.catalog.update.microsoft.com/search.aspx?q=kb3140245)
 
 
#### Step 2
This script creates registry keys to enable TLS 1.1, 1.2 in Windows 7


##### WinHTTP Registry Entries: 
Microsoft Easy-Fix DOES create these keys as well
```
- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp
  DWORD DefaultSecureProtocols=0x00000A00	(32-bits and 64-bits)

- HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp
  DWORD DefaultSecureProtocols=0x00000A00	(64-bits)
```

##### SChannel Registry Entries: 
Microsoft Easy-Fix does NOT create these keys since these protocols are disabled by default.
```
- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client 
  DWORD DisabledByDefault=0x00000000

- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client
  DWORD DisabledByDefault=0x00000000
```  
 > Microsoft Articles: DWORD DisabledByDefault (on 32-bit Windows), DWORD DisabledByDefault (on 64-bit Windows)
 > CPanel Articles:     DWORD DisabledByDefault (on 32-bit Windows), QWORD DisabledByDefault (on 64-bit Windows)


##### Internet Setting Registry Entries: 
Microsoft Easy-Fix DOES create these keys, but this script does NOT.
```
- HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings:	
  DOWRD SecureProtocols = 0xA80

- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings:	
  DOWRD SecureProtocols = 0xA80
```


### References: 
 - [Microsoft TLS Article](https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-wi)
 - [Microsoft Windows Versions](https://docs.microsoft.com/en-us/windows/desktop/sysinfo/operating-system-version)
 - [CPanel TLS Article](https://documentation.cpanel.net/display/CKB/How+to+Configure+Microsoft+Windows+7+to+use+TLS+Version+1.2)
 - PS2EXE: Fork of Marcus Sholtes' fork of Ingo Karstein's script to compile Powershell scripts to Windows executable files. This project is also available on [Microsoft Technet](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-9b4b0493/view/Discussions#content)
