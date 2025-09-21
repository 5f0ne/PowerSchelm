function Get-21SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "Registry event (WmiEventConsumerToFilter activity detected)",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 21
        StartTime = $StartTime
        EndTime   = $EndTime
    }

    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            UtcTime     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "UtcTime" } | Select-Object -ExpandProperty '#text'  
            User        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "User" } | Select-Object -ExpandProperty '#text'
            Operation   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Operation" } | Select-Object -ExpandProperty '#text'
            EventType   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "EventType" } | Select-Object -ExpandProperty '#text'
            Consumer    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Consumer" } | Select-Object -ExpandProperty '#text' 
            Filter      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Filter" } | Select-Object -ExpandProperty '#text'
        }
    }

    $parsed | Export-Csv -Path "sysmon-21.csv" -NoTypeInformation
}
