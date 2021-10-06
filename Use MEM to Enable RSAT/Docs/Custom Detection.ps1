# Get RSAT Active Directory ADDS and Bitlocker status, enable if needed
If (!(Get-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0').state -eq 'Installed')
{
Exit 1
}
If (!(Get-WindowsCapability -Online -Name 'Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0').state -eq 'Installed')
{
Exit 1
}

Write-Host "All good"