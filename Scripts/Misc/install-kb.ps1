#======================================
# 			Documentation
#======================================
# Prepared by : Moe Maysami
#				Innovation Product
#				Nielsen
#
# Syntax: Run the scripts from the directory in which you saved the files, for example:
# 	Set-ExecutionPolicy Bypass -Scope Process ; .\install-kb.ps1

# Usage : This script downloads and installs the KB3140245 Windows update.
#
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
Import-Module BitsTransfer

# Get OS Architecture 32 vs 64 bits
$arch=(Get-WmiObject -Class Win32_operatingsystem).Osarchitecture
Write-Output "Windows $arch"
Write-Output "Installing KB3140245 Windows Update"
Write-Output "-----------------------------------"


#======================================
# 			Update
#======================================
# 32-bits Windows 
If ($arch -eq "32-bit") {
    $kbUrl32 = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/windows6.1-kb3140245-x86_cdafb409afbe28db07e2254f40047774a0654f18.msu"
    $kb32 = "windows6.1-kb3140245-x86_cdafb409afbe28db07e2254f40047774a0654f18.msu"
    Start-BitsTransfer -source $kbUrl32
    wusa $kb32 /log:install.log
}
Else {
    $kbUrl64 = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2016/04/windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"
    $kb64 = "windows6.1-kb3140245-x64_5b067ffb69a94a6e5f9da89ce88c658e52a0dec0.msu"
    Start-BitsTransfer -source $kbUrl64
    wusa $kb64 /log:install.log
}

#======================================
#			END
#======================================
Write-Output ""
Write-Output "Completed Installing KB3140245 Update Successfully!"