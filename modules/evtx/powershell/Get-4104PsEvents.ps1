function Get-4104PsEvents {
    param(
        $ErrorActionPreference="SilentlyContinue",
        $EventDesc = "PowerShell Script Block Logging",
        $StartTime = (Get-Date).AddHours(-24),
        $EndTime = (Get-Date)
    )

    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'Microsoft-Windows-PowerShell/Operational'
        Id = 4104
        StartTime = $StartTime
        $EndTime = $EndTime
    }
    
    $parsed = $events | ForEach-Object {
        $xml = [xml]$_.ToXml()
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            ProcessId = $_.Execution.ProcessId
            MessageNumber = $xml.Event.EventData.Data | Where-Object {$_.Name -eq "MessageNumber"} | Select-Object -ExpandProperty '#text'
            MessageTotal = $xml.Event.EventData.Data | Where-Object {$_.Name -eq "MessageTotal"} | Select-Object -ExpandProperty '#text'
            ScriptBlockId = $xml.Event.EventData.Data | Where-Object {$_.Name -eq "ScriptBlockId"} | Select-Object -ExpandProperty '#text'
            ScriptBlockText = $xml.Event.EventData.Data | Where-Object {$_.Name -eq "ScriptBlockText"} | Select-Object -ExpandProperty '#text'
        }
    }
    
    $parsed | Export-Csv -Path "ps-4104.csv" -NoTypeInformation
}