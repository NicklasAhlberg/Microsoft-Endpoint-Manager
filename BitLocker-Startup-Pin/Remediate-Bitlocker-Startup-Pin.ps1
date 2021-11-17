<#	
	.NOTES
	===========================================================================
	 Created on:   	2021-11-13
	 Created by:   	Nicklas Ahlberg
	 Organization: 	nicklasahlberg.se
	 Filename:     	Remediate-Bitlocker-Startup-Pin.ps1
	 Version:       1.0.0.1
	===========================================================================
	.DESCRIPTION
		Use this script in Proactive Remediation to download the tool from an Azure Storage account
	.WARRANTY
		The tool is provided "AS IS" with no warranties
#>

# Create log directory, file and function
$logFolderLocation = 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs'
if (!(Test-Path $logFolderLocation) -eq $true) { New-Item -Path $logFolderLocation -ItemType Dir -ErrorAction Ignore }
$LogFile = "$logFolderLocation\Bitlocker-Startup-Pin.log"

Function Write-Log
{
	param (
		$Log
	)
	
	$TimeStamp = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
	Add-Content $LogFile  "$TimeStamp - $Log"
}

Write-Log -Log "Remediation script started"

Try
{
	# Declare variables
	$DownloadURL = "YourSASURL"
	$ZIP_File = "C:\Windows\temp\Bitlocker-Startup-Pin-Tool.zip" # ZIP-file download location
	$ExtractedFolder = 'C:\Windows\Temp\Bitlocker-Startup-Pin-Tool' # Location to the extraced ZIP-file
	
	# Download the .ZIP-file from storeage account
	Invoke-WebRequest -Uri $DownloadURL -OutFile $ZIP_File
	
	# Extract the .ZIP-file
	Expand-Archive -Path $ZIP_File -DestinationPath $ExtractedFolder -Force
	
	# Execute 
	Try
	{
		cmd /c start /WAIT "$ExtractedFolder\ServiceUI.exe" -Process:explorer.exe "$ExtractedFolder\Bitlocker-Startup-Pin-Tool.exe"
	}
	
	Catch
	{
		Write-Log -Log "Something went wrong"; Write-Log -Log "$_.Exception.Message"; Exit 1
	}
	
	Write-Log -Log "Remediation script has completed successfully"; Exit 0
}

catch
{
	Write-Log -Log "Something went wrong"; Write-Log -Log "$_.Exception.Message"; Exit 1
}