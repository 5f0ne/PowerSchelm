function Get-4672SecurityEvents {
    param(
        $ErrorActionPreference="SilentlyContinue",
        $EventDesc = "Special privileges assigned to new logon",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        Id        = 4672
        StartTime = $StartTime
        EndTime   = $EndTime
    }
    
    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        $privList = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "PrivilegeList" } | Select-Object -ExpandProperty '#text'
        $cleaned = $privList -replace "[`r`n`t]+", " "
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
            PrivilegeList     = $cleaned
        }
    }
    
    $parsed | Export-Csv -Path "security-4672.csv" -NoTypeInformation
}