function Get-3SysmonEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "Network Connection",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 3
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
            Protocol     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Protocol" } | Select-Object -ExpandProperty '#text'
            Initiated    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Initiated" } | Select-Object -ExpandProperty '#text'
            
            SourceIsIpv6 = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourceIsIpv6" } | Select-Object -ExpandProperty '#text'
            SourceIp  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourceIp" } | Select-Object -ExpandProperty '#text'
            SourceHostname  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourceHostname" } | Select-Object -ExpandProperty '#text'
            SourcePort  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourcePort" } | Select-Object -ExpandProperty '#text'
            SourcePortName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourcePortName" } | Select-Object -ExpandProperty '#text'

            DestinationIsIpv6 = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SourceIsIpv6" } | Select-Object -ExpandProperty '#text'
            DestinationIp  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "DestinationIp" } | Select-Object -ExpandProperty '#text'
            DestinationHostname  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "DestinationHostname" } | Select-Object -ExpandProperty '#text'
            DestinationPort  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "DestinationPort" } | Select-Object -ExpandProperty '#text'
            DestinationPortName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "DestinationPortName" } | Select-Object -ExpandProperty '#text'
        }
    }

    $parsed | Export-Csv -Path "sysmon-3.csv" -NoTypeInformation
}