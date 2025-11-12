<#
.SYNOPSIS
    Intune Remediations - Detection
    Prints "Update Notification On/Off/NotPresent"
    Exits 0 when On; 1 otherwise (Off/NotPresent/Error)

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
$ProgressPreference = 'SilentlyContinue'

# Relaunch in 64-bit PowerShell if needed
if (-not [Environment]::Is64BitProcess) {
    & "$env:WINDIR\sysnative\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath"
    $code = $LASTEXITCODE
    $host.SetShouldExit($code); [Environment]::Exit($code)
}

$regPath   = 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
$valueName = 'RestartNotificationsAllowed2'

# Default: non-compliant
$status = 'Update Notification NotPresent'
$code   = 1

try {
    if (Test-Path -LiteralPath $regPath) {
        $val = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue).$valueName
        if ($null -ne $val) {
            if ([int]$val -eq 1) {
                $status = 'Update Notification On'
                $code   = 0
            } elseif ([int]$val -eq 0) {
                $status = 'Update Notification Off'
                $code   = 1
            } else {
                $status = "Update Notification Unknown ($val)"
                $code   = 1
            }
        }
    }
}
catch {
    $status = "Error: $($_.Exception.Message)"
    $code   = 1
}

Write-Output $status
$host.SetShouldExit($code); [Environment]::Exit($code)