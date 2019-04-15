#==========================================================
# 	Upgrade to TLS 1.1, 1.2 Default SecureProtocols
#
#===========================================================
# AUTHOR: Moe Maysami
#
# STEP1 : This script downloads and installs the KB3140245 Windows update.
#
# STEP2 : This script creates registry keys to enable TLS 1.1, 1.2 in Windows 7
#	
#	WinHTTP Registry Entries: Microsoft Easy-Fix DOES create these keys as well
# 	- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp					: DWORD DefaultSecureProtocols=0x00000A00	(32-bits and 64-bits)
#	- HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp		: DWORD DefaultSecureProtocols=0x00000A00	(64-bits)
#
#	SChannel Registry Entries: Microsoft Easy-Fix does NOT create these keys since these protocols are disabled by default.
#	- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client	: DWORD DisabledByDefault=0x00000000
# 	- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client	: DWORD DisabledByDefault=0x00000000
#
#		Microsoft Articles: DWORD DisabledByDefault (on 32-bit Windows), DWORD DisabledByDefault (on 64-bit Windows)
#		CPanel Articles: 	DWORD DisabledByDefault (on 32-bit Windows), QWORD DisabledByDefault (on 64-bit Windows)
#
#
#	Internet Setting Registry Entries: Microsoft Easy-Fix DOES create these keys, but this script does NOT.
#	- HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings:	DOWRD SecureProtocols = 0xA80
#	- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings:	DOWRD SecureProtocols = 0xA80
#
#
# USAGE/SYNTAX: Run the scripts from the directory in which you saved the files, for example:
# 	- Set-ExecutionPolicy Bypass -Scope Process ; & ".\Demo-TLS Upgrade Tool.ps1"
#	- Restart your workstation for the changes to take effect.
#
#
# REFERENCES: 
#	TLS Support 	 https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-wi
#	Windows Versions https://docs.microsoft.com/en-us/windows/desktop/sysinfo/operating-system-version
#	Scripts			 https://documentation.cpanel.net/display/CKB/How+to+Configure+Microsoft+Windows+7+to+use+TLS+Version+1.2


#======================================
#		TERMS and CONDITIONS
#======================================
#	This tool is provided by the contributors "AS IS" and any express or 
#	implied warranties, including, but not limited to, the implied warranties 
#	of MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE are disclaimed. 
#
#	In no event shall the contributors be liable for any direct, indirect, 
#	incidental, special, exemplary, or consequential damages (including, 
#	but not limited to, procurement of substitute goods or services; 
#	loss of use, data, or profits; or business interruption) however caused 
#	and on any theory of liability, whether in contract, strict liability, 
#	or tort (including negligence or otherwise) arising in any way out of 
#	the use of this tool, even if advised of the possibility of such damage.

#======================================
#		Titles and Texts
#======================================
$caption = "TLS Protocol Activation"

$title = "Upgrade Default Protocols as TLS 1.1/1.2"

$TERMS = "TERMS AND CONDITIONS:`n`nThis tool is provided by the contributors 'AS IS' and any express or implied warranties, including, but not limited to, the implied warranties of MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE are disclaimed. In no event shall the contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this tool, even if advised of the possibility of such damage. "

$TERMSlb = "TERMS AND CONDITIONS:`n`nThis tool is provided by the contributors 'AS IS' and any express `nor implied warranties, including, but not limited to, the implied `nwarranties of merchantability and fitness for a particular purpose `nare disclaimed. `n`nIn no event shall the contributors be liable for any direct, indirect, `nincidental, special, exemplary, or consequential damages (including, `nbut not limited to, procurement of substitute goods or services; loss `nof use, data, or profits; or business interruption) however caused `nand on any theory of liability, whether in contract, strict liability, or `ntort (including negligence or otherwise) arising in any way out of the `nuse of this tool, even if advised of the possibility of such damage. "



#======================================
#		Config Windows Coverage
#======================================
#Include Terms
$showTerms 		= 1

# Skip KB Update
$skipKb 		= 0

# Skip Registry Edit 
$skipReg 		= 0

# ONLY Verbose Demo, SKIP Actual KB Install and Reg Edit
$skipKbInstall = 1
$skipRegEdit   = 1
$skipRegIE     = 0

# Update Windows 7
$skipW7 		= 0

# Update Windows 8
$skipW8 		= 0

# Update Windows Server 2008 R2 (Only 64-bit)
$skipS2008 		= 1	#0
$skipS2008Bi 	= 1

# Update Windows Server 2012
$skipS2012 		= 1	#0

# Update Windows 10(Debug)
$skipW10 		= 0


IF ($skipKbInstall -eq 1 -And $skipRegEdit -eq 1) {
	$intro = $intro + " (DEMO)"
} 



#======================================
#			Constant Variables
#======================================

# KB3140245 URLs
#-------------------------------------------
$kbUrlDir = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/"

# Windows 7 (Version Number 6.1)
$kbFileW7B32 = "windows6.1-kb3140245-x86_cdafb409afbe28db07e2254f40047774a0654f18.msu"
$kbFileW7B64 = "windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"

$kbUrlW7B32 = $kbUrlDir + $kbFileW7B32
$kbUrlW7B64 = $kbUrlDir + $kbFileW7B64


# Windows 8 Embedded (Version Number 6.2)
$kbFileW8B32 = "windows8-rt-kb3140245-x86_d68690bf0bc828ea9368a6e25dc6a9b1b3adf151.msu"
$kbFileW8B64 = "windows8-rt-kb3140245-x64_b589173ad4afdb12b18606b5f84861fcf20010d0.msu"

$kbUrlW8B32 = $kbUrlDir + $kbFileW8B32
$kbUrlW8B64 = $kbUrlDir + $kbFileW8B64


# Windows Server 8 R2 (Version Number 6.1)
$kbFileS8B64 = "windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"
$kbFileS8Bi  = "windows6.1-kb3140245-ia64_3eabf0eda3e3a4c73a832a04bf09d402fc942e13.msu"

$kbUrlS8B64 = $kbUrlDir + $kbFileS8B64
$kbUrlS8Bi  = $kbUrlDir + $kbFileS8Bi


# Windows Server 12 (Version Number 6.2)
$kbFileS12  = "windows8-rt-kb3140245-x64_b589173ad4afdb12b18606b5f84861fcf20010d0.msu"
$kbUrlS12   = $kbUrlDir + $kbFileS12
	
#-------------------------------------------	
# Required WinHTTP Registry Entry
#-------------------------------------------
# TLS 1.1 (0x00000200) + TLS 1.2 (0x00000800) =  registry value of 0x00000A00.
$reg32bWinHttp = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$reg64bWinHttp = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$regWinHttpDefault = "DefaultSecureProtocols"
$regWinHttpValue = "0x00000a00"

#-------------------------------------------
# Required SCHannel Protocols Registry Entry
#-------------------------------------------
$regTLS11 = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
$regTLS12 = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
$regTLSDefault = "DisabledByDefault"
$regTLSValue = "0x00000000"

#-------------------------------------------	
# Optional IE Settings Registry Entry
#-------------------------------------------
$regIEsetting1 = "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
$regIEsetting2 = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"

$regIEDefault = "DefaultSecureProtocols"
$regIEValue   = "0x00000a80"

#======================================
# 			Initialization
#======================================
Write-Host
$DebugPreference = "Continue"
# Get PowerShell Version (Get-CimInstance Not Supported in PS V1 and V2)
#  PowerShell.exe -Version i  TEST: Restart PowerShell in Different Versions 
$pShellVer = $PSVersionTable.PSVersion.Major

# Show Program Title & Terms
#-----------------------------
# IF ($showTerms -eq 1) {
	# Write-Debug  "$title $demo`n`n$TERMS" 
	# Write-Host
# } ELSE {
	# Write-Debug  "$title $demo" 
	# Write-Host
# }

# Make Form Caption, Product Title etc.
IF ($skipKbInstall -eq 1 -And $skipRegEdit -eq 1) {
	$demo = "(DEMO)"
} ELSE {
	$demo = ""
} 

$caption = "$caption $demo"
$title   = "$title $demo"

IF ($showTerms -eq 1) {
	$intro = "$title `n`n`n$TERMSlb"
}

# Prompt For Terms and Agreements
#------------------------------------------
$choices = [System.Management.Automation.Host.ChoiceDescription[]](
(New-Object System.Management.Automation.Host.ChoiceDescription "&Yes (Agree and Continue)","Agree and continue with update. "),
(New-Object System.Management.Automation.Host.ChoiceDescription "&No (Cancel)",    "Cancel execution. "))

$userAbort = $host.ui.PromptForChoice($caption, "$intro`n`n`nDo you wish to continue? `n`n", $choices, 1)


# Exit on User Abort (Code 2)
# ---------------------------
IF ($userAbort -eq 1) {
	Write-Host 
	Write-Debug "The program was canceled by user. `nEnabling TLS 1.1, 1.2 was skipped." 
	Exit 2
}

# Show System Architecture
#-----------------------------
IF ($pShellVer -ge 3) {
	# Windows Name/Caption
	$winName=(Get-CimInstance Win32_OperatingSystem).Caption

	# Windows Version
	$winVer=(Get-CimInstance Win32_OperatingSystem).version

	# Architecture 32/64
	$winArch=(Get-CimInstance Win32_OperatingSystem).OSArchitecture	

} ELSEIF ($pShellVer -eq 2) {
	# Windows Name/Caption
	$winName=(Get-WmiObject Win32_OperatingSystem).Caption

	# Windows Version
	$winVer=(Get-WmiObject Win32_OperatingSystem).version
	
	# Architecture 32/64
	$winArch=(Get-WmiObject -Class Win32_operatingsystem).Osarchitecture

} ELSEIF ($pShellVer -eq 1) {
	Write-Host "No Update Implemented for PowerShell $pShellVer. " 
	Exit 3
}



# Alt. Arch Methods: Pointer Size 4=32-bits, 8=64-bits
$intptrSize = [System.IntPtr]::Size

$skipWin= 1
IF ($winVer -like "6.1.*" -And $winName -like "*Windows 7*") {
	$skipWin= $skipW7
	$winOS = 7

	IF ($winArch -eq "32-bit"){
		$kbUrl  = $kbUrlW7B32
		$kbFile = $kbFileW7B32
	} ELSE {
		$kbUrl = $kbUrlW7B64 
		$kbFile = $kbFileW7B64
	}
	
} ELSEIF ($winVer -like "6.2.*" -And $winName -like "*Windows 8*") {
	$skipWin= $skipW8
	$winOS = 8

	IF ($winArch -eq "32-bit"){
		$kbUrl = $kbUrlW8B32
		$kbFile = $kbFileW8B32		
	} ELSE {
		$kbUrl = $kbUrlW8B64 
		$kbFile = $kbFileW8B64 
	}

} ELSEIF ($winVer -like "6.1.*" -And $winName -like "*Windows Server 2008 R2*") {
	$winOS = 'Server 2008 R2'

	IF ($winArch -eq "64-bit"){
		$skipWin= $skipS2008
		$kbUrl = $kbUrlS8B64 
		$kbFile = $kbFileS8B64
	} ELSE {
		$skipWin= $skipS2008Bi
		$kbUrl  = $kbUrlS8Bi
		$kbFile = $kbFileS8Bi
	}
	
} ELSEIF ($winVer -like "6.2.*" -And $winName -like "*Windows Server 2012*") {
	$skipWin= $skipS2012
	$winOS = 'Server 2012'

	$kbUrl = $kbUrlS12
	$kbFile = $kbFileS12
	
	
} ELSEIF ($winVer -like "10.*" -And $winName -like "*Windows 10*") {
	# No Update Needed
	
	# **** Debug Local ****
	$skipWin= $skipW10
	$winOS = 10
	$kbUrl = $kbUrlW7B64 
	$kbFile = $kbFileW7B64 	
	
} ELSE {

	# Exit on No Update Implemented (Code 3)
	# --------------------------------------
	$skipWin= 1
	$winOS = $winVer
	Write-Host 
	Write-Host "No Update Implemented for `nWindows $winOS ($winName), $winArch System. " 
	Exit 4
}

# Exit on Skipped Windows (Code 4)
# --------------------------------
IF ($skipWin -eq 1) {
	Write-Debug "Windows $winOS ($winName), $winArch System`n`nEnabling TLS 1.1, 1.2 is nor required neither implemented. `n`nPress OK to Exit. "
	Exit 5
}

#======================================
# 			Update KB3140245
#======================================
Import-Module BitsTransfer
Write-Host

$Path2EXE = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
$ParentDir2EXE = [System.IO.Path]::GetDirectoryName($Path2EXE)
$kbFilePath = $(Join-Path -Path $ParentDir2EXE -ChildPath $kbFile)
$kbLogPath  = $(Join-Path -Path $ParentDir2EXE -ChildPath "KB3140245 install.log")
 
# Windows Update Applicable
IF ($skipKb -eq 0 -And $skipWin -eq 0) {
	Write-Warning "Install Microsoft update KB3140245 for Windows $winOS ($winName), $winArch system. "
	Start-BitsTransfer -source $kbUrl -destination $kbFilePath


	IF ($skipKbInstall -eq 0) {
		wusa $kbFilePath /log:$kbLogPath 
		# wusa $kbFile /log:install.log
		Do {
			sleep 2
			$instanceCount = (Get-Process | Where { $_.Name -eq "wusa" } | Measure-Object).Count
		} while ($instanceCount -gt 0)
	}
	
	# Prompt Choice for Completion of KB Update
	#------------------------------------------
	Write-Host
	$choices = [System.Management.Automation.Host.ChoiceDescription[]](
	(New-Object System.Management.Automation.Host.ChoiceDescription "&Yes (Continue)","Continue, Microsoft update completed. "),
	(New-Object System.Management.Automation.Host.ChoiceDescription "&No (Cancel)",    "Abort,   Microsoft update failed. "))

	$kbFailed = $host.ui.PromptForChoice($caption, "Was the installation of Microsoft update for Windows successful?`n`n", $choices, 1)
}


# Exit on Failure (code 5)
# ------------------------
Write-Host
IF ($kbFailed -eq 1) {
	Write-Error "Installation of Microsoft Update for Windows $winOS ($winName), $winArch system failed. Enabling TLS 1.1, 1.2 was skipped. "
	Exit 6
}


#======================================
# Start Execution of Registry Keys
#======================================
Write-Host
$regLog ="Windows Registry Modification: Setting TLS 1.1, 1.2 as Default `n"


IF ($skipReg -eq 0 -And  $kbFailed -eq 0) {
	#--------------------------------------
	#	Start Execution of WinHTTP 
	#--------------------------------------
	$regLog = $regLog + "`n--------------------------------- `n"
	$regLog = $regLog + "WinHTTP Registry Keys: `n"
	$regLog = $regLog + "--------------------------------- `n"

	# Add 32-bits Registry 
	$regLog = $regLog + "Creating key $reg32bWinHttp`n"
	IF(!(Test-Path $reg32bWinHttp)) {
		$regLog = $regLog + "	- Missing Path, Will be generated`n" 
		IF ($skipRegEdit -eq 0){
			New-Item -Path $reg32bWinHttp -Force | Out-Null
			New-ItemProperty -Path $reg32bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
		}
	}
	ELSE {
		IF ($skipRegEdit -eq 0){	
			New-ItemProperty -Path $reg32bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
		}
	}
	 
	# Add Additional Registry for 64-bits
	IF($winArch -eq "64-bit") {
		$regLog = $regLog + "Creating 64-bit key $reg64bWinHttp`n"

		IF(!(Test-Path $reg64bWinHttp)) {
			$regLog = $regLog + "	- Missing Path, Will be generated`n" 
			IF ($skipRegEdit -eq 0){
				New-Item -Path $reg64bWinHttp -Force | Out-Null
				New-ItemProperty -Path $reg64bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
			}
		}
		ELSE {
			IF ($skipRegEdit -eq 0){		
				New-ItemProperty -Path $reg64bWinHttp -Name $regWinHttpDefault -Value $regWinHttpValue -PropertyType DWORD -Force | Out-Null
			}
		}
	}
	$regLog = $regLog + "`n> $regWinHttpDefault with value $regWinHttpValue`n"
	
	#--------------------------------------
	# Start Execution of SChannel
	#--------------------------------------
	$regLog = $regLog + "`n--------------------------------- `n"
	$regLog = $regLog + "SChannel Registry Keys:`n"
	$regLog = $regLog + "--------------------------------- `n"
	
	# Add TLS1.1
	$regLog = $regLog + "Creating key $regTLS11`n"
	IF(!(Test-Path $regTLS11)) {
		$regLog = $regLog + "	- Missing Path, Will be generated`n" 
		IF ($skipRegEdit -eq 0){		
			New-Item -Path $regTLS11 -Force | Out-Null
			New-ItemProperty -Path $regTLS11 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
		}
	} ELSE {
		IF ($skipRegEdit -eq 0){
			New-ItemProperty -Path $regTLS11 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
		}
	}

	# Add TLS1.2 
	$regLog = $regLog + "Creating key $regTLS12`n"
	IF(!(Test-Path $regTLS12)) {
		$regLog = $regLog + "	- Missing Path, Will be generated`n" 
		IF ($skipRegEdit -eq 0){
			New-Item -Path $regTLS12 -Force | Out-Null
			New-ItemProperty -Path $regTLS12 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
		}
	} ELSE {
		IF ($skipRegEdit -eq 0){
			New-ItemProperty -Path $regTLS12 -Name $regTLSDefault -Value $regTLSValue -PropertyType DWORD -Force | Out-Null
		}
	}
	$regLog = $regLog + "`n> $regTLSDefault with value $regTLSValue`n" 



	#--------------------------------------
	# Start Execution of IE Settings
	#--------------------------------------
	IF ($skipRegIE -eq 0) {
		$regLog = $regLog + "`n--------------------------------- `n"
		$regLog = $regLog + "IE Internet Registry Keys:`n"
		$regLog = $regLog + "--------------------------------- `n"
		
		# Set Internet Setting TLS in HKLU
		$regLog = $regLog + "Creating key $regIEsetting1`n"
		IF(!(Test-Path $regIEsetting1)) {
			$regLog = $regLog + "	- Missing Path, Will be generated`n" 
			IF ($skipRegEdit -eq 0){		
				New-Item -Path $regIEsetting1 -Force | Out-Null
				New-ItemProperty -Path $regIEsetting1 -Name $regIEDefault -Value $regIEValue -PropertyType DWORD -Force | Out-Null
			}
		} ELSE {
			IF ($skipRegEdit -eq 0){
				New-ItemProperty -Path $regIEsetting1 -Name $regIEDefault -Value $regIEValue -PropertyType DWORD -Force | Out-Null
			}
		} 

		# Set Internet Setting TLS in HKLM
		$regLog = $regLog + "Creating key $regIEsetting2`n"
		IF(!(Test-Path $regIEsetting2)) {
			$regLog = $regLog + "	- Missing Path, Will be generated`n" 
			IF ($skipRegEdit -eq 0){
				New-Item -Path $regIEsetting2 -Force | Out-Null
				New-ItemProperty -Path $regIEsetting2 -Name $regIEDefault -Value $regIEValue -PropertyType DWORD -Force | Out-Null
			}
		} ELSE {
			IF ($skipRegEdit -eq 0){
				New-ItemProperty -Path $regIEsetting2 -Name $regIEDefault -Value $regIEValue -PropertyType DWORD -Force | Out-Null
			}
		}
		$regLog = $regLog + "`n> $regIEDefault with value $regIEValue`n" 
	}
	
	Write-Host $regLog	
}

#======================================
#			END
#======================================
Write-Host
IF ($kbFailed -eq 0 -And $skipWin -eq 0) {
	Write-Debug "Completed Enabling TLS 1.1, 1.2 Successfully. `n`nPress OK to Exit. "
	Exit 0
} ELSEIF ($skipKb -eq 1 -And $skipReg -eq 1) {
	Write-Warning "Windows $winOS ($winName), $winArch system. `n`nEnabling TLS 1.1, 1.2 was skipped. `n`nPress OK to Exit. "
	Exit 0

}

