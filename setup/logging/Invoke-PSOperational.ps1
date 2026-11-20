# Enable PowerShell Script Block Logging (Event ID 4104) via Registry
# Requires Administrator privileges

$ErrorActionPreference = 'Stop'

# Define registry path (handles both 64-bit and 32-bit paths)
$paths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging",
    "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
)

foreach ($path in $paths) {
    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    
    # Enable Script Block Logging (required for 4104 events)
    Set-ItemProperty -Path $path -Name "EnableScriptBlockLogging" -Value 1 -Type DWord -Force
    
    # Optional: Enable Invocation Logging (adds start/stop events - generates more logs)
    Set-ItemProperty -Path $path -Name "EnableScriptBlockInvocationLogging" -Value 1 -Type DWord -Force
}

# Refresh Group Policy
gpupdate /force

Write-Host "PowerShell Script Block Logging enabled. Check Event Viewer: Microsoft-Windows-PowerShell/Operational for ID 4104 events." -ForegroundColor Green
Write-Host "Test with: { 'Test script block' } or Get-Process" -ForegroundColor Yellow

# Verification function
function Test-ScriptBlockLogging {
    Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 10 | 
    Where-Object { $_.Id -eq 4104 } | 
    Select-Object TimeCreated, Id, Message | 
    Format-Table -AutoSize
}
