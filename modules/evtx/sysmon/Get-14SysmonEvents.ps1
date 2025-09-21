function Get-14SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "Registry event (Key and value rename)",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 14
        StartTime = $StartTime
        EndTime   = $EndTime
    }

    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated  = $_.TimeCreated
            UtcTime      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "UtcTime" } | Select-Object -ExpandProperty '#text'  
            User         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "User" } | Select-Object -ExpandProperty '#text'
            ProcessId    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessId" } | Select-Object -ExpandProperty '#text'
            EventType    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "EventType" } | Select-Object -ExpandProperty '#text'
            Image        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Image" } | Select-Object -ExpandProperty '#text'
            TargetObject = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetObject" } | Select-Object -ExpandProperty '#text'
            NewName      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "NewName" } | Select-Object -ExpandProperty '#text' 
        }
    }

    $parsed | Export-Csv -Path "sysmon-14.csv" -NoTypeInformation
}
