function Get-4688SecurityEvents {
    param(
        $ErrorActionPreference = "SilentlyContinue",
        $EventDesc = "A new process has been created",
        $Path = ""
    )

    if ($Path -eq "") {
        $events = Get-WinEvent -FilterHashtable @{
            LogName   = 'Security'
            Id        = 4688
        }
    }
    else {
        $events = Get-WinEvent -Path $Path -FilterHashtable @{
            LogName = 'Security'
            Id      = 4688
        }
    }
    Write-Host "test"
   Write-Host $events
    
    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated        = $_.TimeCreated
            MachineName        = $_.MachineName
            EventId            = $_.Id
            EventRecordId      = $_.RecordId
            EventDescription   = $EventDesc

            SubjectUserSid     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectUserSid" } | Select-Object -ExpandProperty '#text'
            SubjectUserName    = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectUserName" } | Select-Object -ExpandProperty '#text'
            SubjectDomainName  = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectDomainName" } | Select-Object -ExpandProperty '#text'
            SubjectLogonId     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "SubjectLogonId" } | Select-Object -ExpandProperty '#text'
            
            NewProcessId       = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "NewProcessId" } | Select-Object -ExpandProperty '#text'
            NewProcessName     = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "NewProcessName" } | Select-Object -ExpandProperty '#text'
            CreatorProcessId   = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "CreatorProcessId" } | Select-Object -ExpandProperty '#text'
            CommandLine        = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "CommandLine" } | Select-Object -ExpandProperty '#text'
            TokenElevationType = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TokenElevationType" } | Select-Object -ExpandProperty '#text'
        }
    }
    
    $parsed | Export-Csv -Path "security-4688.csv" -NoTypeInformation
}
