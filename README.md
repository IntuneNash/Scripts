Scope

Applies to Windows 10 and Windows 11 endpoints managed by Microsoft Intune.
Targets devices where registry value:
HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings\RestartNotificationsAllowed2

must be set to 1 (DWORD) to allow restart notifications.


Components


Detection Script

Checks if RestartNotificationsAllowed2 exists and equals 1.
Outputs status and returns:

0 → Compliant (On)
1 → Non-compliant (Off/NotPresent/Error)





Remediation Script

Creates registry key if missing.
Sets RestartNotificationsAllowed2 = 1.
Outputs:

Remediated: Update Notification set to On
No change: Update Notification already On
Error: <message>


Exit codes:

0 → Success (changed or already compliant)
1 → Error






Pre-Requisites

Intune environment with Endpoint Analytics enabled.
Devices must allow PowerShell execution via Intune.
Scripts must run as System and in 64-bit PowerShell.


Deployment Steps
1. Create a Proactive Remediation Package

Navigate to:
Intune Admin Center → Reports → Endpoint Analytics → Proactive Remediations → Create script package
Name:
Enable Windows Update Restart Notifications
Description:
Ensures restart notifications are enabled for Windows Update.

2. Upload Scripts

Detection script: Use the provided detection script.
Remediation script: Use the provided remediation script.

3. Configure Script Settings

Run this script using the logged-on credentials: No (run as System)
Run script in 64-bit PowerShell: Yes
Enforce script signature check: Optional (based on org policy)

4. Assign to Device Groups

Target the appropriate device group(s).
Schedule frequency (recommended: Daily or Hourly for compliance).


Validation

After deployment, check:

Intune Reports → Endpoint Analytics → Proactive Remediations
Status should show:

Compliant → Detection exit code 0
Remediated → Remediation applied successfully
Error → Investigate logs






Troubleshooting

Error: Access Denied
Ensure script runs as System and device is online.
Registry Key Missing After Remediation
Confirm remediation script executed; check Intune logs.
Persistent Non-Compliance
Verify no conflicting GPO or third-party tool overwriting registry value
