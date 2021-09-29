<#	
	.NOTES
	===========================================================================
	 Created on:   	2021-09-28
	 Created by:   	Nicklas Ahlberg
	 Blog: 			https://nicklasahlberg.se
	 Filename:     	IE11 Removal - Detection.ps1
	===========================================================================
	.DESCRIPTION
		Delivered as-is with no warranties or guarantees
#>

$IEexist = Get-WindowsCapability -Online -Name Browser.InternetExplorer~~~~0.0.11.0

if ($IEexist.State -eq 'Installed')
{
	Write-Host "IE11 is installed and should be remidiated"
	Exit 1
}

else
{
	Write-Host "IE11 is not installed remediation is not needed"
	Exit 0
}