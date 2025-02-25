<#	
	.NOTES
	===========================================================================
	 Created on:   	2021-11-13
	 Updated on:   	2024-10-23
	 Created by:   	Nicklas Ahlberg
	 Organization: 	rockenroll.tech
	 Filename:     	Detect-Bitlocker-Startup-PIN.ps1
	 Version:       2024.10.23
	===========================================================================
	.DESCRIPTION
		Use this script in Proactive Remediation to detect wether a Bitlocker startup PIN has been set to the device or not.
	.WARRANTY
		The tool is provided "AS IS" with no warranties
#>

# Make sure the BitLocker Startup PIN Tool is not already running (overlapPINg schedule)
$bitLockerToolProcess = Get-Process -Name Bitlocker-Startup-PIN-Tool -ErrorAction SilentlyContinue
if (! $bitLockerToolProcess) {
	
	# Get Bitlocker status
	$BitLocker = Get-BitLockerVolume -MountPoint $env:SystemDrive
	if ($BitLocker.VolumeStatus -ne 'FullyDecrypted') {
		if ($BitLocker.KeyProtector.KeyProtectorType -notcontains 'TPMPIN') {
			Write-Host "OS-disk is encrypted but startup PIN was not found. Remediation is needed"
			Exit 1
		}
		
		else {
			Write-Host "OS-disk is encrypted and startup PIN was found. No need to remediate"
			Exit 0
		}
		
	}
	
	else {
		Exit 0 # Exit if Bitlocker is not enabled on the device
	}
}

else {
	Exit 0 # Exit if the tool process is already running
}