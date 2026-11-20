param(
      # $ErrorActionPreference = "SilentlyContinue", 
      # Path to write Live Box Forensics output
      $Output = ".\results\windows-event-collection",
      # Time back to collect events
      [int]$MinutesBack = 10
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

# Import common
. .\modules\common\New-Directory.ps1

# Import sysmon
. .\modules\evtx\sysmon\Get-1SysmonEvents.ps1
. .\modules\evtx\sysmon\Get-3SysmonEvents.ps1
. .\modules\evtx\sysmon\Get-11SysmonEvents.ps1
. .\modules\evtx\sysmon\Get-19SysmonEvents.ps1
. .\modules\evtx\sysmon\Get-20SysmonEvents.ps1
. .\modules\evtx\sysmon\Get-21SysmonEvents.ps1
. .\modules\evtx\sysmon\Get-22SysmonEvents.ps1

# Import PSOps
. .\modules\evtx\powershell\Get-4104PsEvents.ps1


#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$machineName = $env:computername.Replace(" ", "_")
$basePath = "$Output\$machineName.$startDateTimeFormatStr"

New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

Write-Host "Start"
Get-4104PsEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-1SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-3SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-11SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-19SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-20SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-21SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Get-22SysmonEvents -MinutesBack $MinutesBack -OutputPath $basePath
Write-Host "End"