function Get-13SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "Registry  event (Value set)",
        [int]$MinutesBack = 10,
        $EndTime = (Get-Date),
        $StartTime = $EndTime.AddMinutes(-$MinutesBack),
        $OutputPath = ".",
        $OutputName = "sysmon-13.csv"
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 13
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
            Details      = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Details" } | Select-Object -ExpandProperty '#text'           
        }
    }

    $parsed | Export-Csv -Path "$OutputPath\$OutputName" -NoTypeInformation
}
