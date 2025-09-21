function Get-4647SecurityEvents {
    param(
        $ErrorActionPreference="SilentlyContinue",
        $EventDesc = "User initiated logoff",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        Id        = 4647
        StartTime = $StartTime
        EndTime   = $EndTime
    }
    
    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated      = $_.TimeCreated
            MachineName      = $_.MachineName
            EventId          = $_.Id
            EventRecordId    = $_.RecordId
            EventDescription = $EventDesc
            TargetUserSid    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserSid" } | Select-Object -ExpandProperty '#text'
            TargetUserName   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserName" } | Select-Object -ExpandProperty '#text'
            TargetDomainName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetDomainName" } | Select-Object -ExpandProperty '#text'
            TargetLogonId    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetLogonId" } | Select-Object -ExpandProperty '#text'
        }
    }
    
    $parsed | Export-Csv -Path "security-4647.csv" -NoTypeInformation
}