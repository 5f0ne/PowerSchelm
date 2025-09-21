function Get-19SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "WMI event (WmiEventFilter activity detected)",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 19
        StartTime = $StartTime
        EndTime   = $EndTime
    }

    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated    = $_.TimeCreated
            UtcTime        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "UtcTime" } | Select-Object -ExpandProperty '#text'  
            User           = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "User" } | Select-Object -ExpandProperty '#text'
            Operation      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Operation" } | Select-Object -ExpandProperty '#text'
            EventType      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "EventType" } | Select-Object -ExpandProperty '#text'
            EventNamespace = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "EventNamespace" } | Select-Object -ExpandProperty '#text'
            Name           = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Name" } | Select-Object -ExpandProperty '#text' 
            Query          = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Query" } | Select-Object -ExpandProperty '#text' 
        }
    }

    $parsed | Export-Csv -Path "sysmon-19.csv" -NoTypeInformation
}
