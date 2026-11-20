function Get-20SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "WMI event (WmiEventConsumer activity detected)",
        [int]$MinutesBack = 10,
        $EndTime = (Get-Date),
        $StartTime = $EndTime.AddMinutes(-$MinutesBack),
        $OutputPath = ".",
        $OutputName = "sysmon-20.csv"
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 20
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
            Name           = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Name" } | Select-Object -ExpandProperty '#text' 
            Type           = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Type" } | Select-Object -ExpandProperty '#text'
            Destination    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Destination" } | Select-Object -ExpandProperty '#text' 
        }
    }

    $parsed | Export-Csv -Path "$OutputPath\$OutputName" -NoTypeInformation
}
