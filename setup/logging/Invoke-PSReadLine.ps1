# PowerShell script to enable Module Logging for PSReadLine specifically
# Run as Administrator

# Create ModuleLogging policy key if it doesn't exist
$moduleLoggingPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging"
if (-not (Test-Path $moduleLoggingPath)) {
    New-Item -Path $moduleLoggingPath -Force | Out-Null
}

# Enable module logging
Set-ItemProperty -Path $moduleLoggingPath -Name "EnableModuleLogging" -Value 1 -Type DWord

# Create ModuleNames subkey if it doesn't exist
$moduleNamesPath = "$moduleLoggingPath\ModuleNames"
if (-not (Test-Path $moduleNamesPath)) {
    New-Item -Path $moduleNamesPath -Force | Out-Null
}

# Add PSReadLine to the modules to log (exact module name)
Set-ItemProperty -Path $moduleNamesPath -Name "PSReadLine" -Value "PSReadLine" -Type String