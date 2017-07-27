<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.142
	 Created on:   	7/27/2017 1:25 PM
	 Created by:   	Riley Childs <me@rileychilds.me>
	 Organization: Sober Implementation Labs	<rileychilds.me>
	 Filename: InstallMentor.ps1
	===========================================================================
	.DESCRIPTION
		This script recreates the Mentor Graphics batch install file for PADS so it can be used anywhere by modifying a few enviromental variables based on the $PSScriptRoot. This script assumes the mentor files are in the same directory as this script
#>

param
(

	[parameter(Mandatory = $true)]
	[string]$mentorBatchFile
	
)

if (Test-Path $PSScriptRoot\$mentorBatchFile)
{
	#Set some inital variables
	$currentComputerName = $env:computername
	$oldScriptPath = "$PSScriptRoot\$mentorBatchFile"
	$newScriptPath = "$PSScriptRoot\$currentComputerName-mentorinstall.bat"
<# Lets go ahead and update the source content locations #>
<# Make the new paths #>
<# Old content: SET "MIPPATH={OldSourceDir}\padsvx.2.2_mib.exe" #>
	$MIPPathEnvVariable = "SET `"MIPPATH=$PSScriptRoot\padsvx.2.2_mib.exe"

<# Old Content: <source value="{OldSourceDir}\padsvx.2.2_mib.exe"/> #>
	$XMLDataMIPPath = "$PSScriptRoot\padsvx.2.2_mib.exe"
	
	#Lets remove any scripts that are still around
	Remove-Item -Path "$newScriptPath*"
	#lets make a new file for our updated script
	New-Item -Path "$newScriptPath"
	#Lets replace the lines
	(Get-Content -Path "$oldScriptPath") -replace 'SET "MIPPATH=[^"]*', $MIPPathEnvVariable -replace '(?<=<source value=")[^"]*', $XMLDataMIPPath | Set-Content $newScriptPath
	
	#start the install
	start-process "cmd.exe" "/c $newScriptPath"
	#Lets add the license info
	
}

else
{
	echo "CANNOT FIND MENTORBATCH FILE, EXITING"
	exit 1
}
