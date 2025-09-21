function Get-22SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "DNS",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 22
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
            Image        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Image" } | Select-Object -ExpandProperty '#text'
            QueryName    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "QueryName" } | Select-Object -ExpandProperty '#text'
            QueryStatus  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "QueryStatus" } | Select-Object -ExpandProperty '#text' 
            QueryResults = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "QueryResults" } | Select-Object -ExpandProperty '#text'
        }
    }

    $parsed | Export-Csv -Path "sysmon-22.csv" -NoTypeInformation
}
