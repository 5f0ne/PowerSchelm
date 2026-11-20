function Get-11SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "File created",
        [int]$MinutesBack = 10,
        $EndTime = (Get-Date),
        $StartTime = $EndTime.AddMinutes(-$MinutesBack),
        $OutputPath = ".",
        $OutputName = "sysmon-11.csv"
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 11
        StartTime = $StartTime
        EndTime   = $EndTime
    }

    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated    = $_.TimeCreated
            UtcTime        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "UtcTime" } | Select-Object -ExpandProperty '#text'  
            User           = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "User" } | Select-Object -ExpandProperty '#text'
            ProcessId      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessId" } | Select-Object -ExpandProperty '#text'
            Image          = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Image" } | Select-Object -ExpandProperty '#text'
            TargetFilename = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetFilename" } | Select-Object -ExpandProperty '#text'
        }
    }

    $parsed | Export-Csv -Path "$OutputPath\$OutputName" -NoTypeInformation
}
