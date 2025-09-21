function Get-4648SecurityEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "A logon was attempted using explicit credentials",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        Id        = 4648
        StartTime = $StartTime
        EndTime   = $EndTime
    }
    
    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated       = $_.TimeCreated
            MachineName       = $_.MachineName
            EventId           = $_.Id
            EventRecordId     = $_.RecordId
            EventDescription  = $EventDesc
            SubjectUserSid    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectUserSid" } | Select-Object -ExpandProperty '#text'
            SubjectUserName   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectUserName" } | Select-Object -ExpandProperty '#text'
            SubjectDomainName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectDomainName" } | Select-Object -ExpandProperty '#text'
            SubjectLogonId    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectLogonId" } | Select-Object -ExpandProperty '#text'    
            LogonGuid         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "LogonGuid" } | Select-Object -ExpandProperty '#text'
            TargetUserName    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserName" } | Select-Object -ExpandProperty '#text'
            TargetDomainName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetDomainName" } | Select-Object -ExpandProperty '#text'
            TargetLogonGuid   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetLogonGuid" } | Select-Object -ExpandProperty '#text'
            TargetServerName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetServerName" } | Select-Object -ExpandProperty '#text'
            TargetInfo        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetInfo" } | Select-Object -ExpandProperty '#text'
            ProcessId         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessId" } | Select-Object -ExpandProperty '#text'
            ProcessName       = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessName" } | Select-Object -ExpandProperty '#text'
            IpAddress         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpAddress" } | Select-Object -ExpandProperty '#text'
            IpPort            = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpPort" } | Select-Object -ExpandProperty '#text'
        }
    }
    $parsed | Export-Csv -Path "security-4648.csv" -NoTypeInformation
}