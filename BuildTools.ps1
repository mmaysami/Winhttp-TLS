#======================================================
#	Modified from Markus Scholtes, DEVK 2016
# 	Create EXEs in sub-Dir "ToolsEXE"
#======================================================
# USAGE/SYNTAX:
# 	ps2exe.ps1 -inputFile script.ps1 -outputFile script.exe -elevated -title 'Nielsen Product Support' -version '1.0.0.0' -verbose -noConsole
#
# NOTE1: Run Flag -runtime20 on Windows 10, cause runtime issue of BitsTransfer not loading properly.
# NOTE2: Run Flag -elevated  on PS2, might cause runtime issues.

#	 Target Folder of Tool Scripts
#---------------------------------------
$pShellVer  = $PSVersionTable.PSVersion.Major
$SCRIPTROOT = Split-Path $SCRIPT:MyInvocation.MyCommand.Path -parent

$Build20	= 1
$Build40	= 1
$BuildEXE	= 1
$BuildCMD	= 0
# $Verbose	= 1

$Ext		= "*.ps1"
$PS2EXE 	= "$SCRIPTROOT\ps2exe.ps1"
$SRCRelPath = "Scripts\"
$EXE20RelPath = "ToolsEXE-PS2"
$EXE40RelPath = "ToolsEXE-PS4"

$SRCPath    = "$SCRIPTROOT\$SRCRelPath"
$EXE20Path  = "$SCRIPTROOT\$EXE20RelPath"
$EXE40Path  = "$SCRIPTROOT\$EXE40RelPath"


# 		Tool Info/Versions
#---------------------------------------
$myTitle   = "TLS Support" 
$myCompany = "" 
$myProduct = "TLS Protocol Upgrade"  
$myVersion = "1.0.0"
# $myIcon 	= "$SRCPath\icon.ico"


# 		Write Out Paths
#---------------------------------------
Write-Host ""
Write-Host ">>> Build  Root : $SCRIPTROOT"
Write-Host ">>> PS2EXE Root : $PS2EXE"
Write-Host ">>> Source Path : $SRCPath"
Write-Host ">>> EXEPS2 Path : $EXE20Path"
Write-Host ">>> EXEPS4 Path : $EXE40Path"
Write-Host ""


# 		Clear Old Build Files
#---------------------------------------
if ($Build20) { Remove-Item	-path "$EXE20Path\*" }
if ($Build40) { Remove-Item	-path "$EXE40Path\*" }		
	
#	List PS1 Files and Convert Them
#---------------------------------------
$srcFiles = Get-ChildItem "$SRCPATH\$Ext"
foreach ($srcFile in $srcFiles){
	# Write-Host ">>> Source File : $($srcFile.Replace($SCRIPTROOT,''))"
	
	if ($Build20) {
		$exe20File = "$EXE20Path\$($srcFile.Name.Replace('.ps1','.exe'))"
		$cmd20File = "$EXE20Path\$($srcFile.Name.Replace('.ps1','-CMD.exe'))"

		if ($BuildEXE) {
			Write-Host ">>> EXE 20 File : $($exe20File.Replace($SCRIPTROOT,''))"
			."$PS2EXE" -inputFile "$srcFile" -outputFile "$exe20File" -noConsole -runtime20 -elevated	-title $myTitle -company $myCompany -product $myProduct  -version $myVersion -iconFile $myIcon
			}
			
		if ($BuildCMD) {
			Write-Host ">>> CMD 20 File : $($cmd20File.Replace($SCRIPTROOT,''))"		
			."$PS2EXE" -inputFile "$srcFile" -outputFile "$cmd20File" 		   -runtime20 -elevated	-title $myTitle -company $myCompany -product $myProduct  -version $myVersion -iconFile $myIcon  
			}
	}

	if ($Build40) {
		$exe40File = "$EXE40Path\$($srcFile.Name.Replace('.ps1','.exe'))"
		$cmd40File = "$EXE40Path\$($srcFile.Name.Replace('.ps1','-CMD.exe'))"

		if ($BuildEXE) {
			Write-Host ">>> EXE 40 File : $($exe40File.Replace($SCRIPTROOT,''))"
			."$PS2EXE" -inputFile "$srcFile" -outputFile "$exe40File" -noConsole -elevated	-title $myTitle -company $myCompany -product $myProduct  -version $myVersion -iconFile $myIcon
			}

		if ($BuildCMD) {
			Write-Host ">>> CMD 40 File : $($cmd40File.Replace($SCRIPTROOT,''))"		
			."$PS2EXE" -inputFile "$srcFile" -outputFile "$cmd40File" 		   -elevated	-title $myTitle -company $myCompany -product $myProduct  -version $myVersion -iconFile $myIcon
			}

	}
}


Write-Host "Build Completed!"
# $NULL = Read-Host "Press enter to exit"


# Usage:
# 
# powershell.exe -command &'.\ps2exe.ps1' [-inputFile] '<file_name>' [-outputFile] '<file_name>'
#                [-verbose] [-debug] [-runtime20|-runtime30|-runtime40] [-lcid <id>] [-x86|-x64] [-Sta|-Mta]
#                [-noConsole] [-iconFile '<file_name>'] [-elevated]
#                [-title '<title-string>'] [-description '<description-string>']  [-company '<company-string>']
#                [-product '<product-string>'] [-copyright '<copyright-string>']  [-version '<version-string>']
# 
#    inputFile = powerShell script that you want to convert to EXE
#   outputFile = destination EXE file name
#      verbose = output verbose informations - if any
#        debug = generate debug informations for output file
#    runtime20 = this switch forces PS2EXE to create a config file for the generated EXE that contains the
#                supported .NET Framework versions"" setting for .NET Framework 2.0 for PowerShell 2.0
#    runtime30 = this switch forces PS2EXE to create a config file for the generated EXE that contains the
#                supported .NET Framework versions"" setting for .NET Framework 4.0 for PowerShell 3.0
#    runtime40 = this switch forces PS2EXE to create a config file for the generated EXE that contains the
#                supported .NET Framework versions"" setting for .NET Framework 4.0 for PowerShell 4.0
#         lcid = location ID for the compiled EXE. Current user culture if not specified.
#          x86 = compile for 32-bit runtime only
#          x64 = compile for 64-bit runtime only
#          sta = Single Thread Apartment Mode
#          mta = Multi Thread Apartment Mode
#    noConsole = the resulting EXE file will be a Windows Forms app without a console window.
#     iconFile = icon for the compiled EXE
#     elevated = include manifest to request admin privileges
#        title = title to include in assembly information
#  description = description to include in assembly information
#      company = company name to include in assembly information
#      product = product name to include in assembly information
#    copyright = copyright to include in assembly information
#      version = version to include in assembly information