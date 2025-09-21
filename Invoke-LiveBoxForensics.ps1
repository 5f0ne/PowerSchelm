param($ErrorActionPreference = "SilentlyContinue", 
      # Path to write Live Box Forensics output
      $Output = ".\results\liveboxforensics", 
      # Path for alternate data stream enumeration
      $AdsEnumPath = $env:USERPROFILE,
      # Path for directory / file enumeration
      $FileEnumPath = $env:USERPROFILE,
      # Path for shortcut enumeration
      $LnkEnumPath = $env:USERPROFILE,
      # Enumerates only files with the given file extension in $FileEnumPath. Example: -FileEnumFilters "pdf, docx, png" 
      # If no filters are given (default value), all files in $FileEnumPath are going to be enumerated
      $FileEnumFilters = "", 
      # If true, searches for alternate data streams in all files located in $AdsEnumPath
      $EnumerateADS = $false, 
      # If true, enumerates all files to provide a list of file paths located in $FileEnumPath
      $EnumerateFiles = $false,
      # If true, enumerates all shortcuts to provide a list of the shortcut`s target property located in $LnkEnumPath
      $EnumerateShortcuts = $false,
      # If true, enumerate file association in the registry and their associated programm to open it 
      $EnumerateFileAssociation = $false,
      # If true, zip the result files
      $Archive = $false
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

# Import common
. .\modules\common\New-Directory.ps1
. .\modules\common\Get-Hashes.ps1
. .\modules\common\Get-ComputerName.ps1
. .\modules\common\Export-ExecutionTime.ps1
. .\modules\common\Export-FileHashes.ps1
. .\modules\common\New-Archive.ps1

# Import Input
. .\modules\Input\Read-Json.ps1

# Import Output
. .\modules\output\Export-AsCsv.ps1
. .\modules\output\Export-AsFile.ps1

# Import Process
. .\modules\process\Get-CimProcess.ps1
. .\modules\process\Format-CimProcess.ps1
. .\modules\process\Get-ProcessFileVersion.ps1
. .\modules\process\Format-ProcessFileVersion.ps1

# Import Network
. .\modules\network\Get-Tcp.ps1
. .\modules\network\Format-Tcp.ps1
. .\modules\network\Get-Udp.ps1
. .\modules\network\Format-Udp.ps1
. .\modules\network\Format-NetRoute.ps1
. .\modules\network\Format-NetAdapter.ps1
. .\modules\network\Format-DnsCache.ps1
. .\modules\network\Get-DnsCache.ps1
. .\modules\network\Get-Adapter.ps1
. .\modules\network\Get-Route.ps1

# Import Firewall
. .\modules\firewall\Format-FwProfile.ps1
. .\modules\firewall\Format-FwRule.ps1
. .\modules\firewall\Get-FwProfile.ps1
. .\modules\firewall\Get-FwRule.ps1

# Import SMB
. .\modules\smb\Format-Map.ps1
. .\modules\smb\Format-Session.ps1
. .\modules\smb\Format-Share.ps1
. .\modules\smb\Get-Map.ps1
. .\modules\smb\Get-Session.ps1
. .\modules\smb\Get-Share.ps1
. .\modules\smb\Get-SmbShareAcl.ps1

# Import Service
. .\modules\service\Format-CimService.ps1
. .\modules\service\Get-CimService.ps1

# Import LocalUser/LocalGroup
. .\modules\local\user\Format-User.ps1
. .\modules\local\user\Get-User.ps1
. .\modules\local\group\Format-Group.ps1
. .\modules\local\group\Get-Group.ps1
. .\modules\local\group\Format-GroupMemberList.ps1
. .\modules\local\group\Get-GroupMemberList.ps1

# Import ScheduledTasks
. .\modules\scheduled-task\Format-STask.ps1
. .\modules\scheduled-task\Format-STaskInfo.ps1
. .\modules\scheduled-task\Get-STask.ps1
. .\modules\scheduled-task\Get-STaskInfo.ps1
. .\modules\scheduled-task\Export-STask.ps1
. .\modules\scheduled-task\Export-STaskAction.ps1

# Import PowerShell
. .\modules\powershell\Export-PowerShellHistory.ps1
. .\modules\powershell\Export-PowerShellTranscript.ps1

# Import WMI
. .\modules\wmi\Get-WmiConsumerFilterData.ps1

# Import ADS
. .\modules\ads\Get-AlternateDataStream.ps1

# Import Prefetch
. .\modules\prefetch\Get-PrefetchFiles.ps1

# Import Evtx
. .\modules\evtx\Get-EvtxLogs.ps1

# Import Registry
. .\modules\registry\Get-InstalledPrograms.ps1
. .\modules\registry\Get-KeysOfInterest.ps1
. .\modules\registry\Get-FileAssociation.ps1

# Import Hotfix
. .\modules\hotfix\Get-HotfixInfo.ps1

# Import FileEnum
. .\modules\file\Invoke-FileEnum.ps1

# Import ShortcutEnum
. .\modules\file\Invoke-ShortcutEnum.ps1

# Import Autostart Enum
. .\modules\file\Invoke-AutostartEnum.ps1

# Import Printer
. .\modules\printer\Get-PrinterInfo.ps1


#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$machineName = $env:computername.Replace(" ", "_")
$basePath = "$Output\$machineName.$startDateTimeFormatStr"

New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# System
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\00-system"
New-Directory -Path $pathBase

$result = systeminfo
$result | Export-AsFile -Path "$pathBase\system-info.txt"

$result = cmd.exe /c set
$result | Export-AsFile -Path "$pathBase\system-variables.txt"

$result = klist
$result | Export-AsFile -Path "$pathBase\cached-kerberos-tickets.txt"

$result = whoami /all
$result | Export-AsFile -Path "$pathBase\user-account-information.txt"

Get-TimeZone | Select-Object * | Export-AsCsv -Path "$pathBase\timezone.csv"

#---------------------------------------------------------------------------------------------------------
# Process Information
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\01-process"
New-Directory -Path $pathBase

# Processes
Get-CimProcess | Format-CimProcess | Export-AsCsv -Path "$pathBase\processes.csv"

# Processes with User Names
Get-Process -IncludeUserName | Format-Table -AutoSize | Out-String | Export-AsFile -Path "$pathBase\processes-with-usernames.txt"

# Processes with File Version
Get-ProcessFileVersion | Format-ProcessFileVersion | Export-AsCsv -Path "$pathBase\processes-with-fileversion.csv"

# tasklist cmd
$result = tasklist /m 
$result | Export-AsFile -Path "$pathBase\tasklist.txt"

#---------------------------------------------------------------------------------------------------------
# Network Usage
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\02-network"
New-Directory -Path $pathBase

# TCP
Get-Tcp | Format-Tcp | Export-AsCsv -Path "$pathBase\tcp.csv"

# UDP
Get-Udp | Format-Udp | Export-AsCsv -Path "$pathBase\udp.csv"

# DNS
Get-DnsCache | Format-DnsCache | Export-AsCsv -Path "$pathBase\dns-cache.csv"
Get-DnsClientCache | Format-Table -AutoSize | Out-String | Export-AsFile -Path "$pathBase\dns-cache-table.txt"

# Route
Get-Route | Format-NetRoute | Export-AsCsv -Path "$pathBase\net-route.csv"
Get-NetRoute | Format-Table -AutoSize | Out-String | Export-AsFile -Path "$pathBase\net-route-table.txt"

# Network Adapter
Get-Adapter | Format-NetAdapter | Export-AsCsv -Path "$pathBase\net-adapter.csv"
Get-NetAdapter | Format-Table -AutoSize | Out-String | Export-AsFile -Path "$pathBase\net-adapter-table.txt"

# netstat
$result = netstat -nao 
$result += " "
$result += netstat -ab 
$result | Export-AsFile -Path "$pathBase\netstat.txt"

# arp
$result = arp -a
$result | Export-AsFile -Path "$pathBase\arp.txt"

# ipconfig
$result = ipconfig /all
$result | Export-AsFile -Path "$pathBase\ipconfig.txt"

# route
$result = route print
$result | Export-AsFile -Path "$pathBase\route.txt"

# dns
$result = ipconfig /displaydns
$result | Export-AsFile -Path "$pathBase\ipconfig-dns.txt"

#---------------------------------------------------------------------------------------------------------
# Firewall
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\03-firewall"
New-Directory -Path $pathBase

Get-FwProfile | Format-FwProfile | Export-AsCsv -Path "$pathBase\firewall-profiles.csv"
Get-FwRule | Format-FwRule | Export-AsCsv -Path "$pathBase\firewall-rules.csv"

#---------------------------------------------------------------------------------------------------------
# SMB
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\04-smb"
New-Directory -Path $pathBase

Get-Map | Format-Map | Export-AsCsv -Path "$pathBase\smb-mappings.csv"
Get-Share | Format-Share | Export-AsCsv -Path "$pathBase\smb-shares.csv"
Get-Session | Format-Session | Export-AsCsv -Path "$pathBase\smb-sessions.csv"

Get-SmbShareAcl -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Services
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\05-service"
New-Directory -Path $pathBase

# Services
Get-CimService | Format-CimService | Export-AsCsv -Path "$pathBase\services.csv"

#---------------------------------------------------------------------------------------------------------
# Local Users
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\06-local-user"
New-Directory -Path $pathBase

# Local User
Get-User | Format-User | Export-AsCsv -Path "$pathBase\local-user.csv"

#---------------------------------------------------------------------------------------------------------
# Local Group and Group Members
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\07-local-group"
New-Directory -Path $pathBase

# Local Group
Get-Group | Format-Group | Export-AsCsv -Path "$pathBase\local-group.csv"
#Local Group Members
Get-GroupMemberList | Format-GroupMemberList | Export-AsCsv -Path "$pathBase\local-group-members.csv"

#---------------------------------------------------------------------------------------------------------
# Scheduled Tasks
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\08-scheduled-tasks"
New-Directory -Path $pathBase

Get-STask | Format-STask | Export-AsCsv -Path "$pathBase\scheduled-tasks.csv"
Get-STaskInfo | Format-STaskInfo | Export-AsCsv -Path "$pathBase\scheduled-tasks-info.csv"

# --> Export Scheduled Task Description as XML
$p = "$pathBase\export"
New-Directory -Path $p
Export-STask -Path $p

# --> Export Scheduled Task Actions from XML
Export-STaskAction -XmlPath $p -ResultPath $pathBase

#---------------------------------------------------------------------------------------------------------
# PowerShell History and Transcripts
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\09-powershell"
New-Directory -Path $pathBase
$history = "$pathBase\history"
New-Directory -Path $history
$transcript = "$pathBase\transcript"
New-Directory -Path $transcript

Export-PowerShellHistory -Path $history
Export-PowerShellTranscript -Path $transcript

#---------------------------------------------------------------------------------------------------------
# WMI Event Filter and Consumer
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\10-wmi"
New-Directory -Path $pathBase

Get-WmiConsumerFilterData -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Printer
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\11-printer"
New-Directory -Path $pathBase

Get-PrinterInfo -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Prefetch
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\12-prefetch"
New-Directory -Path $pathBase

Get-PrefetchFiles -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Available Log Files
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\13-evtx"
New-Directory -Path $pathBase

Get-EvtxLogs -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Installed Programs
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\14-installed-programs"
New-Directory -Path $pathBase

Get-InstalledPrograms -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Installed Hotfixes
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\15-installed-hotfixes"
New-Directory -Path $pathBase

Get-HotfixInfo -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Autostart Folder
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\16-autostart-folder"
New-Directory -Path $pathBase

Invoke-AutostartEnum -Path $pathBase

#---------------------------------------------------------------------------------------------------------
# Registry: Keys of Interest (KoI) and File Association
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\17-registry"
New-Directory -Path $pathBase

Get-KeysOfInterest -Path $pathBase

if ($EnumerateFileAssociation) {
      Get-FileAssociation -Path $pathBase
}

#---------------------------------------------------------------------------------------------------------
# Shortcut Enumeration
#---------------------------------------------------------------------------------------------------------

if ($EnumerateShortcuts) {
      $pathBase = "$basePath\18-shortcut-enumeration"
      New-Directory -Path $pathBase
      Invoke-ShortcutEnum -LnkEnumPath $LnkEnumPath -ResultPath $pathBase
}


#---------------------------------------------------------------------------------------------------------
# Alternate Data Streams
#---------------------------------------------------------------------------------------------------------

if ($EnumerateADS) {
      $pathBase = "$basePath\19-alternate-data-streams"
      New-Directory -Path $pathBase
      Get-AlternateDataStream -ResultPath $pathBase -AdsEnumPath $AdsEnumPath
}

#---------------------------------------------------------------------------------------------------------
# File Enumeration
#---------------------------------------------------------------------------------------------------------

if ($EnumerateFiles) {
      $pathBase = "$basePath\20-file-enumeration"
      New-Directory -Path $pathBase
      Invoke-FileEnum -EnumPath $FileEnumPath -EnumFilters $FileEnumFilters -ResultPath $pathBase
}

#---------------------------------------------------------------------------------------------------------
# Execution Time
#---------------------------------------------------------------------------------------------------------

# Write Execution Time
Export-ExecutionTime -Path $basePath -StartDateTime $startDateTime -StartDateTimeFormatStr $startDateTimeFormatStr

#---------------------------------------------------------------------------------------------------------
# Error
#---------------------------------------------------------------------------------------------------------

# Save errors
$pathBase = "$basePath\99-error"
New-Directory -Path $pathBase
$error | Export-AsFile -Path "$pathBase\error.txt"

#---------------------------------------------------------------------------------------------------------
# Hash all Files
#---------------------------------------------------------------------------------------------------------

Export-FileHashes -HashPath $basePath -ResultPath $basePath

#---------------------------------------------------------------------------------------------------------
# Create archive
#---------------------------------------------------------------------------------------------------------

if ($Archive) {
      New-Archive -ResultPath $Output -ArchivePath $basePath -FileName "$machineName.$startDateTimeFormatStr"
}