# Winhttp-TLS
Enable TLS 1.1/1.2 Security Protocols and set them as default for WinHTTP


### STEP1 : 
This script downloads and installs the KB3140245 Windows update.
 - http://www.catalog.update.microsoft.com/search.aspx?q=kb3140245
 
### STEP2 : 
This script creates registry keys to enable TLS 1.1, 1.2 in Windows 7
	
##### WinHTTP Registry Entries: Microsoft Easy-Fix DOES create these keys as well
- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp:
  - DWORD DefaultSecureProtocols=0x00000A00	(32-bits and 64-bits)

- HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp: 
  - DWORD DefaultSecureProtocols=0x00000A00	(64-bits)

##### SChannel Registry Entries: Microsoft Easy-Fix does NOT create these keys since these protocols are disabled by default.
- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client	: 
  - DWORD DisabledByDefault=0x00000000

- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client	: 
  - DWORD DisabledByDefault=0x00000000
  
  
 
- Microsoft Articles: DWORD DisabledByDefault (on 32-bit Windows), DWORD DisabledByDefault (on 64-bit Windows)
- CPanel Articles: 	  DWORD DisabledByDefault (on 32-bit Windows), QWORD DisabledByDefault (on 64-bit Windows)


##### Internet Setting Registry Entries: Microsoft Easy-Fix DOES create these keys, but this script does NOT.
- HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings:	
  - DOWRD SecureProtocols = 0xA80

- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings:	
  - DOWRD SecureProtocols = 0xA80


### USAGE: 
Run the scripts from the directory in which you saved the files, for example:

- Set-ExecutionPolicy Bypass -Scope Process ; & ".\Demo-TLS Upgrade Tool.ps1"

- Restart your workstation for the changes to take effect.


### REFERENCES: 

TLS Support 	 
- https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-wi

Windows Versions 
- https://docs.microsoft.com/en-us/windows/desktop/sysinfo/operating-system-version

Scripts			 
- https://documentation.cpanel.net/display/CKB/How+to+Configure+Microsoft+Windows+7+to+use+TLS+Version+1.2
