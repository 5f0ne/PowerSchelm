function Get-4720SecurityEvents {
    param(
        $ErrorActionPreference="SilentlyContinue",
        $EventDesc = "A user account was created",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        Id        = 4720
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
            TargetUserName    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserName" } | Select-Object -ExpandProperty '#text'
            TargetDomainName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetDomainName" } | Select-Object -ExpandProperty '#text'
            TargetSid         = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetSid" } | Select-Object -ExpandProperty '#text'
            SubjectUserSid    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectUserSid" } | Select-Object -ExpandProperty '#text'
            SubjectUserName   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectUserName" } | Select-Object -ExpandProperty '#text'
            SubjectDomainName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectDomainName" } | Select-Object -ExpandProperty '#text'
            SubjectLogonId    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectLogonId" } | Select-Object -ExpandProperty '#text'
            PrivilegeList     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "PrivilegeList" } | Select-Object -ExpandProperty '#text'
            SamAccountName    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SamAccountName" } | Select-Object -ExpandProperty '#text'
            UserPrincipalName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "UserPrincipalName" } | Select-Object -ExpandProperty '#text'
        }
    }
    
    $parsed | Export-Csv -Path "security-4720.csv" -NoTypeInformation
}


