<#
 Intune Remediations - Remediation
 Sets: HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\RestartNotificationsAllowed2 = 1 (DWORD)
 Output: "Remediated: Update Notification set to On" | "No change: Update Notification already On" | "Error: ..."
 Exit code: 0 on success (changed or already compliant), 1 on error

.SYNOPSIS
    This script modifies registry settings related to update notifications.

.DESCRIPTION
    This PowerShell script is provided "as-is" without any warranty of any kind, either express or implied,
    including but not limited to the implied warranties of merchantability and/or fitness for a particular purpose.
    Use of this script is at your own risk. Microsoft and the author assume no liability for any damages
    resulting from the use or misuse of this script.

.NOTES
    Author: Joshua Nash
    Date: November 5, 2025
    Version: 1.0
    Tested on: Windows 10/11    Tested on: Windows 10/11
#>



$ErrorActionPreference = 'Stop'

# Ensure 64-bit PowerShell (relaunch via sysnative if needed)
if (-not [Environment]::Is64BitProcess) {
    & "$env:WINDIR\sysnative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File $PSCommandPath
    exit $LASTEXITCODE
}

$regPath   = 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
$valueName = 'RestartNotificationsAllowed2'
$desired   = 1

try {
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    $current = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

    if ($null -eq $current -or [int]$current -ne $desired) {
        New-ItemProperty -Path $regPath -Name $valueName -PropertyType DWord -Value $desired -Force | Out-Null
        $verify = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop).$valueName
        if ([int]$verify -eq $desired) {
            Write-Output "Remediated: Update Notification set to On"
            exit 0
        } else {
            Write-Output "Error: Failed to set Update Notification to On (post-check value = $verify)"
            exit 1
        }
    } else {
        Write-Output "No change: Update Notification already On"
        exit 0
    }
}
catch {
    Write-Output "Error: $($_.Exception.Message)"
    exit 1
}
``
