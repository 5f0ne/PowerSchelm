function Get-4625SecurityEvents {
    param(
        $ErrorActionPreference="SilentlyContinue",
        $EventDesc = "An account failed to log on",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        Id        = 4625
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
            TargetUserSid     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserSid" } | Select-Object -ExpandProperty '#text'
            TargetUserName    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserName" } | Select-Object -ExpandProperty '#text'
            TargetDomainName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetDomainName" } | Select-Object -ExpandProperty '#text'
            TargetLogonId     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetLogonId" } | Select-Object -ExpandProperty '#text'
            
            Status            = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "Status" } | Select-Object -ExpandProperty '#text'
            FailureReason     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "FailureReason" } | Select-Object -ExpandProperty '#text'
            SubStatus         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubStatus" } | Select-Object -ExpandProperty '#text'

            LogonType         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "LogonType" } | Select-Object -ExpandProperty '#text'
            LogonProcessName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "LogonProcessName" } | Select-Object -ExpandProperty '#text'
            WorkstationName   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "WorkstationName" } | Select-Object -ExpandProperty '#text'
            ProcessId         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessId" } | Select-Object -ExpandProperty '#text'
            ProcessName       = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "ProcessName" } | Select-Object -ExpandProperty '#text'
            IpAddress         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpAddress" } | Select-Object -ExpandProperty '#text'
            IpPort            = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpPort" } | Select-Object -ExpandProperty '#text'
        }
    }
    
    $parsed | Export-Csv -Path "security-4625.csv" -NoTypeInformation
    
}