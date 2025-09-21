function Get-1SysmonEvents {
    param(
        $ErrorActionPreference="SilentlyContinue",
        $EventDesc = "Process created",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Microsoft-Windows-Sysmon/Operational'
        Id        = 1
        StartTime = $StartTime
        EndTime   = $EndTime
    }

    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated       = $_.TimeCreated
            UtcTime           = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "UtcTime" } | Select-Object -ExpandProperty '#text'  
            User              = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "User" } | Select-Object -ExpandProperty '#text'
            ProcessId         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessId" } | Select-Object -ExpandProperty '#text'
            ParentProcessId   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ParentProcessId" } | Select-Object -ExpandProperty '#text'
            CommandLine       = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "CommandLine" } | Select-Object -ExpandProperty '#text'
            ParentCommandLine = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ParentCommandLine" } | Select-Object -ExpandProperty '#text'
            Image             = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Image" } | Select-Object -ExpandProperty '#text'
            ParentImage       = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ParentImage" } | Select-Object -ExpandProperty '#text'
        }
    }

    $parsed | Export-Csv -Path "sysmon-1.csv" -NoTypeInformation
}