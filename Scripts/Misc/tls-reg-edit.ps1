#======================================
# 			Documentation
#======================================
# Prepared by : Moe Maysami
#				Innovation Product
#				Nielsen
#
# Syntax: Run the scripts from the directory in which you saved the files, for example:
# 	Set-ExecutionPolicy Bypass -Scope Process ; .\tls-reg-edit.ps1
#	Restart your workstation for the changes to take effect.

# Usage : This script creates registry keys to enable TLS 1.1, 1.2 in Windows 7
# 	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp
#	HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp
#	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1
# 	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2

# Sources: 
#	https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-wi
#	https://documentation.cpanel.net/display/CKB/How+to+Configure+Microsoft+Windows+7+to+use+TLS+Version+1.2

#======================================
#		TERMS and CONDITIONS
#======================================
#	This script is provided by the contributors 
#	"AS IS"  and any express or implied warranties, including, but not limited to, 
#	the implied warranties of MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
#	PURPOSE are disclaimed. In no event shall the contributors be liable for any 
#	direct, indirect, incidental, special, exemplary, or consequential damages 
#	(including, but not limited to, procurement of substitute goods or services; 
#	loss of use, data, or profits; or business interruption) however caused 
#	and on any theory of liability, whether in contract, strict liability, or tort (including 
#	negligence or otherwise) arising in any way out of the use of this software, even 
#	if advised of the possibility of such damage.

#======================================
# 			Initialization
#======================================
# Get OS Architecture 32 vs 64 bits
$arch=(Get-WmiObject -Class Win32_operatingsystem).Osarchitecture

# Required WinHTTP Registry Entry
# TLS 1.1 (0x00000200) + TLS 1.2 (0x00000800) =  registry value of 0x00000A00.
$reg32bWinHttp = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$reg64bWinHttp = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$regWinHttpDefault = "DefaultSecureProtocols"
$regWinHttpValue = "0x00000a00"


# Required SCHannel Protocols Registry Entry
$regTLS11 = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
$regTLS12 = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
$regTLSDefault = "DisabledByDefault"
$regTLSValue = "0x00000000"

#======================================
# Start Execution of WinHTTP
#======================================
Clear-Host
Write-Output "Windows $arch"
Write-Output "Enabling TLS 1.1, 1.2 in Registry"
Write-Output "---------------------------------"

Write-Output "Creating WinHTTP Registry Keys..."

# Add 32-bits Registry 
Write-Output "--> Creating registry key $reg32bWinHttp"
IF(!(Test-Path $reg32bWinHttp)) {
	Write-Output "    - Missing Path, Will be generated" 
    New-Item -Path $reg32bWinHttp -Force | Out-Null
    New-ItemProperty -Path $reg32bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
}
ELSE {
    New-ItemProperty -Path $reg32bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
}
Write-Output "    - $regWinHttpDefault with value $regWinHttpValue"

 
# Add Additional Registry for 64-bits
IF($arch -eq "64-bit") {
    Write-Output "--> Creating 64-bits registry key $reg64bWinHttp"

    IF(!(Test-Path $reg64bWinHttp)) {
		Write-Output "    - Missing Path, Will be generated" 	
        New-Item -Path $reg64bWinHttp -Force | Out-Null
        New-ItemProperty -Path $reg64bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
    }
    ELSE {
        New-ItemProperty -Path $reg64bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
    }
	Write-Output "    - $regWinHttpDefault with value $regWinHttpValue"
}

#======================================
# Start Execution of SChannel
#======================================
Write-Output ""
Write-Output "Creating SChannel Registry Keys..."

# Add TLS1.1
Write-Output "--> Creating registry key $regTLS11"
IF(!(Test-Path $regTLS11)) {
	Write-Output "    - Missing Path, Will be generated" 
    New-Item -Path $regTLS11 -Force | Out-Null
    New-ItemProperty -Path $regTLS11 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
    }
ELSE {
    New-ItemProperty -Path $regTLS11 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
}
Write-Output "    - $regTLSDefault with value $regTLSValue" 
 

# Add TLS1.2 
Write-Output "--> Creating registry key $regTLS12"
IF(!(Test-Path $regTLS12)) {
	Write-Output "    - Missing Path, Will be generated" 
    New-Item -Path $regTLS12 -Force | Out-Null
    New-ItemProperty -Path $regTLS12 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
    }
ELSE {
    New-ItemProperty -Path $regTLS12 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
}
Write-Output "    - $regTLSDefault with value $regTLSValue" 

#======================================
#			END
#======================================
Write-Output ""
Write-Output "Completed Enabling TLS1.1,1.2 Successfully!"
