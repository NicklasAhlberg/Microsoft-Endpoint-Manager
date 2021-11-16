<#	
	.NOTES
	===========================================================================
	 Created on:   	2021-11-13
	 Created by:   	Nicklas Ahlberg
	 Organization: 	nicklasahlberg.se
	 Filename:     	Detect-Bitlocker-Startup-Pin.ps1
	 Version:       1.0.0.1
	===========================================================================
	.DESCRIPTION
		Use this script in Proactive Remediation to detect wether a Bitlocker startup pin has been set to the device or not.

#>

# Get Bitlocker status
$BitLocker = Get-BitLockerVolume -MountPoint $env:SystemDrive
if ($BitLocker.VolumeStatus -ne 'FullyDecrypted')
{
	if ($BitLocker.KeyProtector.KeyProtectorType -notcontains 'TPMPin')
	{
		Write-Host "OS-disk is encrypted but startup pin was not found. Remediation is needed"
		Exit 1
	}
	
	else
	{
		Write-Host "OS-disk is encrypted and startup pin was found. No need to remediate"
		Exit 0
	}
	
}

else
{
	Exit 0
}