<#	
	.NOTES
	===========================================================================
	 Created on:   	2021-11-25 06:17
	 Created by:   	Nicklas Ahlberg
	 Organization: 	nicklasahlberg.se
	 Filename:     	MEM Device Sync Tool
	===========================================================================
	.DESCRIPTION
		Use this tool to sync MEM managed devices
	.WARRANTY
		The Tool is provided "AS IS" with no warranties
#>
$MEMAdminTool_Load = {
	
	# Make sure all PowerShell modules are installed
	Try
	{
		Import-Module Microsoft.Graph.Intune -ErrorAction SilentlyContinue
	}
	
	catch
	{
		Install-Module -Name Microsoft.Graph.Intune -Force -Confirm:$false
		Import-Module Microsoft.Graph.Intune -ErrorAction SilentlyContinue
	}
	$logTb.AppendText("Connect to your tenant to get started")
	$logTb.AppendText("`n")
}

# Create log directory, file and function
$logFolderLocation = 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs'
if (!(Test-Path $logFolderLocation) -eq $true) { New-Item -Path $logFolderLocation -ItemType Dir -ErrorAction Ignore }
$LogFile = "$logFolderLocation\MDM-Admin-Tool.log"

function Write-Log
{
	param (
		$Log
	)
	
	$TimeStamp = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
	Add-Content $LogFile  "$TimeStamp - $Log"
}

# Create Write-ToTextbox function
function Write-ToTextbox
{
	param (
		$Text
	)
	$logTb.AppendText("$Text")
	$logTb.AppendText("`n")
}

$connectBtn_Click = {
	#TODO: Place custom script here
	Try
	{
		Connect-MSGraph -ErrorAction SilentlyContinue
		$connectBtn.Visible = $false
		$syncBtn.Visible = $true
		$operatingsystemGrp.Enabled = $true
		$manualGrp.Enabled = $true
		Write-ToTextbox -Text "Successfully connected to your tenant!"
		#$WindowsDevices = '0'; $WindowsDevices = (Get-IntuneManagedDevice | where { $_.OperatingSystem -eq "Windows" } | select -ExpandProperty managedDeviceId).count; Write-ToTextbox -Text "Your tenant has $WindowsDevices Windows devices"
		#$iOSiPadDevices = '0'; $iOSiPadDevices = (Get-IntuneManagedDevice | where { $_.OperatingSystem -eq "iOS/iPadOS" } | select -ExpandProperty managedDeviceId).count; Write-ToTextbox -Text "Your tenant has $iOSiPadDevices iOS/iPadOS devices"
		#$AndroidDevices = '0'; $AndroidDevices = (Get-IntuneManagedDevice | where { $_.OperatingSystem -contains "Android" } | select -ExpandProperty managedDeviceId).count; Write-ToTextbox -Text "Your tenant has $AndroidDevices Android devices"
	}
	
	catch
	{
		Write-ToTextbox -Text "$_.Exception.Message"
	}
}

$syncBtn_Click = {
	
	# If a specific device has been selected
	if ($deviceTb.Text)
	{
		Try
		{
			$deviceText = $deviceTb.Text
			$managedDeviceId = Get-IntuneManagedDevice | Get-MSGraphAllPages | where { $_.DeviceName -eq "$deviceText" } | select -ExpandProperty Id
			Write-ToTextbox -Text "Attemptning to sync $managedDeviceId"
			Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $managedDeviceId
		}
		
		catch
		{
			Write-ToTextbox -Text "$_.Exception.Message"
		}
	}
	
	if ($operatingsystemGrp.Enabled -eq $true)
	{
		# If Windows devices
		if ($windowsPb.BorderStyle -eq 'Fixed3D')
		{
			$Devices = Get-IntuneManagedDevice | Get-MSGraphAllPages | where { $_.OperatingSystem -eq "Windows" } | select -ExpandProperty Id
			$totalDevices = $Devices.count
			Write-ToTextbox -Text "Attemptning to sync $totalDevices Windows devices"
			$progressbaroverlay1.Maximum = $totalDevices; $progressbaroverlay1.Step = 1; $progressbaroverlay1.Value = 0 # Progressbar config
			
			foreach ($Device in $Devices)
			{
				$progressbaroverlay1.PerformStep()
				#Write-ToTextbox -Text "Attemptning to sync $Device"	
				Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $Device
			}
		}
		
		# If iPad devices
		if ($iPadPb.BorderStyle -eq 'Fixed3D')
		{
			$Devices = Get-IntuneManagedDevice | Get-MSGraphAllPages | where { $_.OperatingSystem -eq "iOS" -and $_.model -match 'iPad' } | select -ExpandProperty Id
			$totalDevices = $Devices.count
			Write-ToTextbox -Text "Attemptning to sync $totalDevices iPad devices"
			$progressbaroverlay1.Maximum = $totalDevices; $progressbaroverlay1.Step = 1; $progressbaroverlay1.Value = 0 # Progressbar config
			
			foreach ($Device in $Devices)
			{
				$progressbaroverlay1.PerformStep()
				#Write-ToTextbox -Text "Attemptning to sync $Device"
				Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $Device
			}
		}
		
		# If iPhone devices
		if ($iPhonePb.BorderStyle -eq 'Fixed3D')
		{
			$Devices = Get-IntuneManagedDevice | Get-MSGraphAllPages | where { $_.OperatingSystem -eq "iOS" -and $_.model -match 'iPhone' } | select -ExpandProperty Id
			$totalDevices = $Devices.count
			Write-ToTextbox -Text "Attemptning to sync $totalDevices iPhone devices"
			$progressbaroverlay1.Maximum = $totalDevices; $progressbaroverlay1.Step = 1; $progressbaroverlay1.Value = 0 # Progressbar config
			
			foreach ($Device in $Devices)
			{
				$progressbaroverlay1.PerformStep()
				#Write-ToTextbox -Text "Attemptning to sync $Device"
				Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $Device
			}
		}
		
		# If Android devices
		if ($androidPb.BorderStyle -eq 'Fixed3D')
		{
			$Devices = Get-IntuneManagedDevice | Get-MSGraphAllPages | where { $_.OperatingSystem -contains "Android" } | select -ExpandProperty Id
			$totalDevices = $Devices.count
			Write-ToTextbox -Text "Attemptning to sync $totalDevices Android devices"
			$progressbaroverlay1.Maximum = $totalDevices; $progressbaroverlay1.Step = 1; $progressbaroverlay1.Value = 0 # Progressbar config
			
			foreach ($Device in $Devices)
			{
				$progressbaroverlay1.PerformStep()
				#Write-ToTextbox -Text "Attemptning to sync $Device"
				Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $Device
			}
		}
	}
}

$windowsPb_Click = {
	if ($windowsPb.BorderStyle -eq 'Fixed3D') { $windowsPb.BorderStyle = 'None' }
	
	else
	{
		$windowsPb.BorderStyle = 'Fixed3D'
		$applePb.BorderStyle = 'None'
		$androidPb.BorderStyle = 'None'
		$iPadPb.BorderStyle = 'None'
		$iPhonePb.BorderStyle = 'None'
	}
}

$androidPb_Click = {
	if ($androidPb.BorderStyle -eq 'Fixed3D') { $androidPb.BorderStyle = 'None' }
	
	else
	{
		$androidPb.BorderStyle = 'Fixed3D'
		$windowsPb.BorderStyle = 'None'
		$applePb.BorderStyle = 'None'
		$iPadPb.BorderStyle = 'None'
		$iPhonePb.BorderStyle = 'None'
	}
}

$applePb_Click = {
	#if ($applePb.BorderStyle -eq 'Fixed3D') { $applePb.BorderStyle = 'None' }
	
	$iPadPb.Visible = $true
	$iPhonePb.Visible = $true
	$applePb.BorderStyle = 'None'
	$androidPb.BorderStyle = 'None'
	$windowsPb.BorderStyle = 'None'
}

$manualCb_CheckedChanged = {
	$deviceTb.Enabled = $manualCb.Checked
	$operatingsystemGrp.Enabled = !$manualCb.Checked
}

$iPadPb_Click = {
	if ($iPadPb.BorderStyle -eq 'Fixed3D') { $iPadPb.BorderStyle = 'None' }
	
	else
	{
		$windowsPb.BorderStyle = 'None'
		$iPadPb.BorderStyle = 'Fixed3D'
		$iPhonePb.BorderStyle = 'None'
		$applePb.BorderStyle = 'None'
		$androidPb.BorderStyle = 'None'
	}
}
$iPhonePb_Click = {
	if ($iPhonePb.BorderStyle -eq 'Fixed3D') { $iPhonePb.BorderStyle = 'None' }
	
	else
	{
		$windowsPb.BorderStyle = 'None'
		$iPadPb.BorderStyle = 'None'
		$iPhonePb.BorderStyle = 'Fixed3D'
		$applePb.BorderStyle = 'None'
		$androidPb.BorderStyle = 'None'
	}
}
